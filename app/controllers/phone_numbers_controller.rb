# app/controllers/phone_numbers_controller.rb
class PhoneNumbersController < ApplicationController
    before_action :set_phone_number, only: [:show, :edit, :update, :destroy]
    validates :number, presence: true, length: { minimum: 6, maximum: 16 }
    protect_from_forgery with: :null_session

    def index
      @phone_numbers = PhoneNumber.all
    end
  
    def show
    end
  
    def new
      @phone_number = PhoneNumber.new
    end
  
    def create
      @phone_number = PhoneNumber.new(phone_number_params)
      if @phone_number.save
        redirect_to @phone_number, notice: 'Phone number was successfully created.'
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @phone_number.update(phone_number_params)
        redirect_to @phone_number, notice: 'Phone number was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @phone_number.destroy
      redirect_to phone_numbers_url, notice: 'Phone number was successfully destroyed.'
    end
  
    private
  
    def set_phone_number
      @phone_number = PhoneNumber.find(params[:id])
    end
  
    def phone_number_params
      params.require(:phone_number).permit(:number, :account_id)
    end
  end
  