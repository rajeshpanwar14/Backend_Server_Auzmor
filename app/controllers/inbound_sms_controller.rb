class InboundSmsController < ApplicationController
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

    unless PhoneNumber.exists?(number: to_number, account_id: @current_account.id)
      render_error('to parameter not found')
      return
    end

    if stop_keyword?(text)
      store_stop_entry(from_number, to_number)
    end

    render json: { message: 'inbound sms ok', error: '' }
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
  

  def stop_keyword?(text)
    text.upcase == 'STOP' || text.upcase == 'STOP\n' || text.upcase == 'STOP\r' || text.upcase == 'STOP\r\n'
  end

  def store_stop_entry(from_number, to_number)
    key = "#{STOP_KEY_PREFIX}_#{from_number}_#{to_number}"
    Rails.cache.write(key, true, expires_in: 4.hours)
  end

  def render_error(error_message)
    render json: { message: '', error: error_message }
    return
  end  
end
