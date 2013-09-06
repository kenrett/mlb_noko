require 'rubygems'
require 'pry'
require 'nokogiri'
require 'open-uri'
require 'json'


SCHEDULER.every '10s', :first_in => 0 do
  doodah = {teams:["BOS", "TBR", "NYY", "BAL", "TOR"]}

  send_event('mlb', doodah)
end
