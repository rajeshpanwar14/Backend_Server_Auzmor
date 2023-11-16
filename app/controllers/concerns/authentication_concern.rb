module AuthenticationConcern
    extend ActiveSupport::Concern
  
    STOP_KEY_PREFIX = 'stop_entry'.freeze
    REQUEST_LIMIT_KEY_PREFIX = 'request_limit'.freeze
    REQUEST_LIMIT_PERIOD = 24.hours.freeze
    REQUEST_LIMIT_COUNT = 50
  
    included do
      before_action :authenticate_request
    end
  
    private
  
    def authenticate_request
      authenticate_or_request_with_http_basic do |username, password|
        account = Account.find_by(username: username, auth_id: password)
        if account
          @current_account = account
        else
          render status: :forbidden, json: { error: 'Access denied' }
        end
      end
    end
  end
  