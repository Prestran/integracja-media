class MainController < ApplicationController
    def index
    end

    def login_handle
        login_handler = LoginHandler.call(params)
    end
end
