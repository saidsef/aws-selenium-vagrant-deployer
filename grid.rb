#filename: grid.rb

require 'selenium-webdriver'
require 'rspec/expectations'
include RSpec::Matchers

def setup
  @driver = Selenium::WebDriver.for(
    :remote,
    url: 'http://127.0.0.1:4444/wd/hub',
    desired_capabilities: :firefox) # you can also use :chrome, :safari, etc.
end

def teardown
  @driver.quit
end

def run
  setup
  yield
  teardown
end

run do
  start_time = Time.now.to_i
  @driver.navigate.to 'http://www.telegraph.co.uk'
  end_time = Time.now.to_i
  total_time = end_time - start_time
  puts "Total Time Taken:", total_time
  @driver.save_screenshot 'screenshot.jpg'
  puts @driver.title
  expect(@driver.title).to eq('The Telegraph - Telegraph online, Daily Telegraph, Sunday Telegraph - Telegraph')
end