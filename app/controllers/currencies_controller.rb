class CurrenciesController < ApplicationController
  def get_currency_amount
    amount = params[:amount].to_i
    currency = Currency.where(from: params[:required_currency_code],
                              to: params[:paying_currency_code]).first
    if currency
      if currency.updated_at < Time.now - 10.seconds
        update_currencies(currency.from)
        currency.reload
      end
      json_return(200, true, { price: amount * currency.rate,
                               paying_currency_code: params[:paying_currency_code] })
    elsif params[:required_currency_code] && params[:paying_currency_code] && amount
      update_currencies(params[:required_currency_code])
      currency = Currency.where(from: params[:required_currency_code],
                                to: params[:paying_currency_code]).first
      json_return(200, true, { price: amount * currency.rate,
                               paying_currency_code: params[:paying_currency_code] })
    else
      json_return(400, false, 'Bad Input')
    end
  end

  private

  def update_currencies(base_currency)
    response = JSON.parse `curl http://api.fixer.io/latest?base=#{base_currency}`
    response["rates"].each do |currency, rate|
      need_to_update_currency = Currency.find_or_create_by(from: response["base"], to: currency)
      need_to_update_currency.rate = rate
      need_to_update_currency.save
    end
  end
end