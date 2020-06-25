require 'capybara/cucumber'
require 'capybara/rspec'
require 'selenium-webdriver'


Capybara.register_driver :test do |app|
  browser_options = ::Selenium::WebDriver::Chrome::Options.new
  browser_options.args << '--headless'
  browser_options.args << '--no-sandbox'
  browser_options.args << '--disable-gpu'
  browser_options.args << '--window-size=1920,1080'
  browser_options.args << '--disable-dev-shm-usage'
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: browser_options
  )
end


Capybara.configure do |config|
  config.default_driver = :test
  # Other irrelevant config stuff...
end

Capybara.run_server = false

Capybara.app_host = 'http://www.google.com'
