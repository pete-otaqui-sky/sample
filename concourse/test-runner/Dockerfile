FROM ruby

RUN apt update
RUN apt install -y chromium chromium-driver
RUN gem install cucumber capybara:3.5 rspec rspec-expectations rspec-wait selenium-webdriver:3.14.1 chromedriver-helper:2.1.0 elasticsearch httparty cucumber-messages cucumber-gherkin websocket-extensions websocket-driver minitest zeitwerk
RUN echo "Done that bit"
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -E -
RUN apt install -y nodejs
