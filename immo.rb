require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'watir'
require 'webdrivers'

agent = Mechanize.new
url = 'https://fr.riviera-realisation.com/espace-reserve'
page = agent.get(url)
agent.user_agent_alias = 'Mac Safari'
form_name = page.forms[1]
form_name.account = ""
form_name.password = ""
button = form_name.button
test1 = form_name.submit
p test1




# page = agent.submit(form_name, button)
# browser = Watir::Browser.new
# browser.goto('http://riviera.prescripteurs.axessia.net')
# p browser.forms
# browser.text_field(data_test: 'email').set '3113'
# browser.text_field(data_test: 'password').set 'o8-|2}79'
# browser.button(name: 'commit').click
