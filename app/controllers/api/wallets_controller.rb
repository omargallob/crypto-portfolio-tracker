class Api::WalletsController < ApplicationController
  def index
    @wallets = Wallet.all
    render :json => @wallets, include: {:balance => {include: :trading_pairs}}
  end
end
