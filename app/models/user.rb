class User < ApplicationRecord
  TEMP_EMAIL_PREFIX = 'bademail@bad.com'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :omniauthable, :registerable, :confirmable,
  :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:login]

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 
  validates_presence_of :first_name, :last_name
  validates :username, presence: :true, uniqueness: { case_sensitive: false }
  validate :validate_login

  attr_writer :login

  def validate_login
    if User.where(email: login).exists?
      errors.add(:login, :invalid)
    end
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        name = auth.extra.raw_info.name.split(' ')
        user = User.new(
          first_name: name.first,
          last_name: name.last,
          username: name.join('-').downcase!,
          #username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["username = :value OR lower(email) = lower(:value)", { :value => login }]).first
    elsif conditions.has_key?(:login) || conditions.has_key?(:email)
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_h).first
    end      
  end

  def email_verified?
    self.email && self.email !~ URI::MailTo::EMAIL_REGEXP
  end

  def login
    @login || self.username || self.email
  end
end
