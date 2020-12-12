require 'nokogiri'
require 'open-uri'
require 'mechanize'

agent = Mechanize.new
page = agent.get('https://facebook.com/?_fb_noscript=1')
agent.user_agent_alias = 'Android'
form_a = page.form
form_a.email = "renardtom@hotmail.fr"
form_a.pass =  "57m9dx8Z+zorro"
page = agent.submit(form_a)
link_a = page.links[1].href
url = "https://m.facebook.com/#{link_a}"
html = open(url)
doc = Nokogiri::HTML(html)
p doc
