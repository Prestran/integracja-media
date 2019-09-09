FactoryBot.define do
    factory :user do
        email { "mailsample@email.com" }
        username { "john-dog" }
        first_name { "John" }
        last_name  { "Dog" }
        www_site { "www.doggydog.com.org.pl" }
        about_me { "Lorem Ipsum is simply dummy text of the printing and typesetting industry." }
    end
  end