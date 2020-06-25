require 'capybara/cucumber'
require 'capybara/rspec'

Capybara.default_driver = :selenium_chrome_headless # :selenium_chrome and :selenium_chrome_headless are also registered
Capybara.current_driver = :selenium_chrome_headless
Capybara.run_server = false

Capybara.app_host = 'http://www.google.com'
