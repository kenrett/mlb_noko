require 'rubygems'
require 'pry'
require 'nokogiri'
require 'open-uri'
require 'json'


# SCHEDULER.every '5m', :first_in => 0 do
  doc = Nokogiri::HTML(open('http://www.baseball-reference.com'))

  al_standings = []

  s = doc.css('#div_AL_standings').text

  by_division = s.split("SRS")

  al_east = by_division[1].split(" ").each_slice(6).to_a
  al_cent = by_division[2].split(" ").each_slice(6).to_a
  al_west = by_division[3].split(" ").each_slice(6).to_a

  al_east.each { |r| r.pop }
  al_cent.each { |r| r.pop }
  al_west.each { |r| r.pop }

  al_east.pop
  al_cent.pop

  al_east_pre = []
  al_cent_pre = []
  al_west_pre = []


  al_east_pre = al_east.each { |f| f.delete(f[1]) }
  al_e_final = al_east_pre.map { |e| {'al_east' => e} }
  al_cent_pre = al_cent.each { |f| f.delete(f[1]) }
  al_c_final = al_cent_pre.map { |e| {'al_east' => e} }
  al_west_pre = al_west.each { |f| f.delete(f[1]) }
  al_w_final = al_west_pre.map { |e| {'al_east' => e} }

  pry.binding

  send_event('mlb', {
    al_east: al_e_final.to_json,
    al_cent: al_c_final.to_json,
    al_west: al_w_final.to_json
    })
# end