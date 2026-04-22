# Learn more: http://github.com/javan/whenever

# config/schedule.rb

# Dynamically set the environment for whenever
set :environment, ENV['RAILS_ENV'] || 'development'

every 1.day, at: "8:00am" do
  runner "Certification.notify_expires_soon"
end

every 1.day, at: "12:00pm" do
  runner "Trip.notify_last_payments"
end

every 1.day, at: "08:00am" do
  runner "Trip.close_finished"
end

