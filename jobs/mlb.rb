require 'rubygems'
require 'pry'
require 'nokogiri'
require 'open-uri'
require 'json'


SCHEDULER.every '4s', :first_in => 0 do
  doc = Nokogiri::HTML(open('http://www.baseball-reference.com'))

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
  n = al_east_pre.transpose
  team = n[0].join(" ")
  wins = n[1].join(" ")
  losses = n[2].join(" ")
  gb = n[3].join(" ")

  # binding.pry


  al_cent_pre = al_cent.each { |f| f.delete(f[1]) }
  al_c_final = al_cent_pre.join(",")
  al_west_pre = al_west.each { |f| f.delete(f[1]) }
  al_w_final = al_west_pre.join(",")
  # al_w_final = al_west_pre.map { |e| {'al_west' => e} }


  send_event('mlb', {
    team: n[0],
    wins: n[1],
    losses: n[2],
    gb: n[3]
    #,
    # al_cent: al_c_final,
    # al_west: al_w_final
  })
end