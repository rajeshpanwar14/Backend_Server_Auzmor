class OutboundSmsController < ApplicationController
    include AuthenticationConcern
    protect_from_forgery with: :null_session

    def create
      error_messages = validate_input_params(['from', 'to', 'text'])
  
      unless error_messages.empty?
        render_error(error_messages.join(', '))
        return
      end

      from_number = params[:from]
      to_number = params[:to]
      text = params[:text]
  
      if stop_entry_exists?(from_number, to_number)
        render_error("sms from #{from_number} to #{to_number} blocked by STOP request")
        return
      end
  
      unless PhoneNumber.exists?(number: from_number, account_id: @current_account.id)
        render_error('from parameter not found')
        return
      end
  
      if request_limit_reached?(from_number)
        render_error("limit reached for from #{from_number}")
        return
      end
  
      render json: { message: 'outbound sms ok', error: '' }
    end
  
    private
  
    def validate_input_params(required_params)
      error_messages = []
    
      required_params.each do |param|
        error_messages << "#{param} is missing" if params[param].blank?
      end
  
      validate_length(error_messages, 'from', params[:from], 6, 16)
      validate_length(error_messages, 'to', params[:to], 6, 16)
      validate_length(error_messages, 'text', params[:text], 1, 120)
    
      error_messages
    end
    
    def validate_length(error_messages, param_name, value, min_length, max_length)
      if value.present? && (value.length < min_length || value.length > max_length)
        error_messages << "#{param_name} is invalid"
      end
    end

    def stop_entry_exists?(from_number, to_number)
      key = "#{STOP_KEY_PREFIX}_#{from_number}_#{to_number}"
      Rails.cache.exist?(key)
    end
  
    def request_limit_reached?(from_number)
      key = "#{REQUEST_LIMIT_KEY_PREFIX}_#{from_number}"
      count = Rails.cache.read(key) || 0
  
      if count >= REQUEST_LIMIT_COUNT
        true
      else
        Rails.cache.write(key, count + 1, expires_in: REQUEST_LIMIT_PERIOD)
        false
      end
    end

    def render_error(error_message)
      render json: { message: '', error: error_message }
      return
    end
end
  