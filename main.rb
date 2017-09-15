require 'capybara'
require 'capybara/poltergeist'
require 'ffaker'
require 'pry'

registrations_number = ARGV.first&.to_i || 1
user_name_base = FFaker::Internet.user_name
password = FFaker::Internet.password

# session = Capybara::Session.new(:webkit)
session = Capybara::Session.new(:selenium)
session.driver.browser.manage.timeouts.page_load = 10
registrations_number.times do |iteration|
  session.visit('https://dev.by/registration')
  user_name = "#{user_name_base}#{iteration}"
  session.fill_in('Юзернейм', with: user_name)
  session.fill_in('Емейл адрес', with: "#{user_name}@mfsa.ru")
  session.fill_in('Пароль', with: password)
  session.fill_in('user_password_confirmation', with: password)
  session.check('user_agreement')
  session.click_button('Зарегистрироваться') rescue nil

  session.visit("https://www.mfsa.info/mail/#{user_name}/1") rescue nil
  session.click_link('подтвердить')
end
puts "Registration completed. Basic user name is #{user_name_base} password is #{password}. " \
  "User names follow \#{user_name}\#{number} pattern."
