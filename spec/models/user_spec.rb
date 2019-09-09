require 'rails_helper'

describe User do
    before(:each) do
        @user = build(:user)
        @user_created = create(:user, email: 'qwerty@abcabc.com', password: 'abc1234', password_confirmation: 'abc1234')
    end

    describe '#validate_login' do
        context 'email and username are the same for user' do
            it 'should add errors to user instance' do
                @user_created.update username: @user_created.email
                @user_created.validate_login
                expect(@user_created.errors.messages).to have_key(:login)
            end
        end

        context 'email and username are different for user' do
            it 'should add no errors to user instance' do
                @user_created.validate_login
                expect(@user_created.errors.messages).to eq Hash.new
            end
        end
    end

    describe '.find_for_database_authentication' do
        context 'method argument has login key and no email key' do
            it 'should return user with given arguments' do
                conditions = {login: 'john-dog'}
                expect(User.find_for_database_authentication(conditions)). to eq @user_created
            end
        end

        context 'method argument has login key and email key' do
            it 'should return user with given arguments' do
                conditions = {email: 'qwerty@abcabc.com', login: 'john-dog'}
                expect(User.find_for_database_authentication(conditions)). to eq @user_created
            end
        end

        context 'method argument has email key and no login key' do
            it 'should return user with given arguments' do
                conditions = {email: 'qwerty@abcabc.com'}
                expect(User.find_for_database_authentication(conditions)). to eq @user_created
            end
        end

        context 'method argument has neither login key not email key' do
            it 'should return nil' do
                conditions = {}
                expect(User.find_for_database_authentication(conditions)). to eq nil
            end
        end
    end

    describe '#email_verified?' do
        context 'user has unproper email address' do
            it 'should return false' do
                @user.update email: "emailsample@asd^.co^m"
                expect(@user.email_verified?).to eq false
            end
        end

        context 'user has proper email address' do
            it 'should return true' do
                expect(@user.email_verified?).to eq true
            end
        end
    end

    describe '#login' do
        context 'user has username' do
            it 'should return users username' do
                expect(@user.login).to eq 'john-dog'
            end
        end

        context 'user does not have username' do
            it 'should return users email' do
                @user.update(username: nil)
                expect(@user.login).to eq @user.email
            end
        end
    end
end