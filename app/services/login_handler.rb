class LoginHandler < ApplicationService
    def initialize(params)
        @params = params
    end

    def call
        redirect_login
    end

    def redirect_login

    end
end