require 'factory_bot_rails'

module ControllerMacros
    def login_student
      # Before each test, create and login the user
      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:student]
        test_student = FactoryBot.create(:student)
        # user.confirm! # Or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
        sign_in test_student
      end
    end
  
    # Not used in this tutorial, but left to show an example of different user types
    # def login_admin
    #   before(:each) do
    #     @request.env["devise.mapping"] = Devise.mappings[:admin]
    #     sign_in FactoryBot.create(:admin) # Using factory bot as an example
    #   end
    # end
  end