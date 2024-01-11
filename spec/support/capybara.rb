RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium, using: :headless_chrome
  end

  Capybara.default_max_wait_time = 2
end
