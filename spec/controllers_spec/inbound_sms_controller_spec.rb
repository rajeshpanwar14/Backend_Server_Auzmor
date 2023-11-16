require 'rails_helper'

RSpec.describe InboundSmsController, type: :controller do
  let(:valid_params) { { from: '654321', to: '123456', text: 'Hello' } }
  let(:invalid_params) { { from: '654321', to: '123456', text: '' } }
  let(:current_account) { Account.new }

  describe 'POST #create' do
    before do
      allow(@controller).to receive(:authenticate_request).and_return(true)
      @controller.instance_variable_set(:@current_account, current_account)
      allow(PhoneNumber).to receive(:exists?).with(number: '123456', account_id: nil).and_return(true)
    end

    it 'responds with success when valid parameters are provided' do
      post :create, params: valid_params
      expect(response).to have_http_status(:success)
      expect(response.body).to eq({ message: 'inbound sms ok', error: '' }.to_json)
    end

    it 'renders an error message when required parameters are missing' do
      post :create, params: invalid_params
      expect(response).to have_http_status(:success)
      expect(response.body).to eq({ message: '', error: 'text is missing' }.to_json)
    end

    it 'stores stop entry in cache when stop keyword is detected' do
      post :create, params: valid_params.merge(text: 'STOP')
      expect(response).to have_http_status(:success)

      from_number = valid_params[:from]
      to_number = valid_params[:to]
      stop_key = "#{InboundSmsController::STOP_KEY_PREFIX}_#{from_number}_#{to_number}"
      expect(Rails.cache.read(stop_key)).to eq(nil)
    end
  end

  describe 'parameter not found' do
    before do
        allow(@controller).to receive(:authenticate_request).and_return(true)
        @controller.instance_variable_set(:@current_account, current_account)
        allow(PhoneNumber).to receive(:exists?).with(number: '123456', account_id: nil).and_return(false)
    end
    it 'renders an error message when "to" parameter is not found in PhoneNumber' do
        post :create, params: valid_params
        expect(response).to have_http_status(:success)
        expect(response.body).to eq({ message: '', error: 'to parameter not found' }.to_json)
    end
  end
end
