require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'watir'
require 'webdrivers'

agent = Mechanize.new
url = 'http://riviera.prescripteurs.axessia.net'
page = agent.get(url)
agent.user_agent_alias = 'Mac Safari'

browser = Watir::Browser.new
browser.goto('http://riviera.prescripteurs.axessia.net')
p browser.forms
# browser.text_field(data_test: 'email').set '3113'
# browser.text_field(data_test: 'password').set 'o8-|2}79'
# browser.button(name: 'commit').click
