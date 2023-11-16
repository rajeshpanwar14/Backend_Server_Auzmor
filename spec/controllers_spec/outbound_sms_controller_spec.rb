require 'rails_helper'

RSpec.describe OutboundSmsController, type: :controller do
  let(:valid_params) { { from: '123456', to: '789012', text: 'Hello, testing!' } }
  let(:current_account) { Account.new }
  before do
    allow(controller).to receive(:authenticate_request).and_return(true)
    @controller.instance_variable_set(:@current_account, current_account)
    allow(PhoneNumber).to receive(:exists?).with(number: '123456', account_id: nil).and_return(true)
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'returns a success response' do
        post :create, params: valid_params
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['error']).to be_empty
      end
    end

    context 'with missing parameters' do
      it 'returns an error response' do
        post :create, params: { from: '123456', to: '789012' }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#validate_input_params' do
    it 'returns an error for missing parameters' do
      error_messages = controller.send(:validate_input_params, [:from, :to, :text])
      expect(error_messages).to include('from is missing', 'to is missing', 'text is missing')
    end
  end

  describe '#stop_entry_exists?' do
    it 'returns true if stop entry exists' do
      allow(Rails.cache).to receive(:exist?).and_return(true)
      expect(controller.send(:stop_entry_exists?, '123456', '789012')).to be_truthy
    end

    it 'returns false if stop entry does not exist' do
      allow(Rails.cache).to receive(:exist?).and_return(false)
      expect(controller.send(:stop_entry_exists?, '123456', '789012')).to be_falsy
    end
  end
end
