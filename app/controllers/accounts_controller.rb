# app/controllers/accounts_controller.rb
class AccountsController < ApplicationController
    before_action :set_account, only: [:show, :edit, :update, :destroy]
    protect_from_forgery with: :null_session

    def index
      @accounts = Account.all
    end
  
    def show
    end
  
    def new
      @account = Account.new
    end
  
    def create
      @account = Account.new(account_params)
      if @account.save
        redirect_to @account, notice: 'Account was successfully created.'
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @account.update(account_params)
        redirect_to @account, notice: 'Account was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @account.destroy
      redirect_to accounts_url, notice: 'Account was successfully destroyed.'
    end
  
    private
  
    def set_account
      @account = Account.find(params[:id])
    end
  
    def account_params
      params.require(:account).permit(:auth_id, :username)
    end
  end
  