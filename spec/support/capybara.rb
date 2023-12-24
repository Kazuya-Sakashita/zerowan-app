require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.register_driver :remote_chrome do |app|
  url = 'http://selenium_chrome:4444/wd/hub' # Docker内のSeleniumサーバーのURL
  capabilities = ::Selenium::WebDriver::Remote::Capabilities.chrome(
    'goog:chromeOptions' => {
      'args' => [
        'no-sandbox',
        'headless',
        'disable-gpu',
        'window-size=1680,1050'
      ]
    }
  )

  Capybara::Selenium::Driver.new(app,
                                 browser: :remote,
                                 url:, # 修正: url変数を指定
                                 capabilities:) # 修正: capabilities変数を指定
end

Capybara.javascript_driver = :remote_chrome

RSpec.configure do |config|
  config.before(:each, type: :feature) do
    Capybara.server_host = 'web' # Dockerコンポーズで定義されたWebアプリケーションのサービス名
    Capybara.server_port = 3001 # Webアプリケーションのポート番号とは異なる番号であること
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end
end
