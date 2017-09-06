require 'rails_helper'

RSpec.describe CurrenciesController, type: :controller do
  let(:api_response) do
      {"base":"USD","date":"2017-09-05","rates":{"AUD":1.2533,"BGN":1.6449,"BRL":3.1177,"CAD":1.239,"CHF":0.95938,"CNY":6.5488,"CZK":21.932,"DKK":6.2558,"GBP":0.77157,"HKD":7.8253,"HRK":6.2383,"HUF":257.69,"IDR":13334.0,"ILS":3.5681,"INR":64.128,"JPY":109.33,"KRW":1130.0,"MXN":17.845,"MYR":4.2614,"NOK":7.8039,"NZD":1.3903,"PHP":51.139,"PLN":3.5627,"RON":3.8659,"RUB":57.96,"SEK":7.9638,"SGD":1.3553,"THB":33.18,"TRY":3.4444,"ZAR":12.944,"EUR":0.84104}}
  end

  describe "get_currency_amount" do
    it "should get currency from api" do
      not_up_to_date_currency = Currency.create(from: "USD", to: "ILS", rate: 3, updated_at: Time.now - 1.days)
      get :get_currency_amount, required_currency_code: "USD", paying_currency_code: "ILS",amount: 100
      expect(JSON.parse(response.body)["payload"]["data"]["price"]).to eq(356.05)
    end

    it "should use current currency" do
      up_to_date_currency = Currency.create(from: "USD", to: "ILS", rate: 3, updated_at: Time.now + 1.days)
      get :get_currency_amount, required_currency_code: "USD", paying_currency_code: "ILS",amount: 100
      expect(JSON.parse(response.body)["payload"]["data"]["price"]).to eq(300)
    end
  end

  describe "parse api response" do
    it "should insert to db all currenices" do
      @controller = CurrenciesController.new
      @controller.instance_eval{ update_currencies("USD") }
    end
  end
end