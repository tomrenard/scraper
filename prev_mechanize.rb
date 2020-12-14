require 'nokogiri'
require 'open-uri'
require 'mechanize'

agent = Mechanize.new
page = agent.get('https://facebook.com/?_fb_noscript=1')
agent.user_agent_alias = 'Mac Safari'
form_a = page.form
p page.forms
# form_a.email = "exemple@email.com"
# form_a.pass =  "1234567"
# page = agent.submit(form_a)
# link_a = page.links[1].href
# url = "https://m.facebook.com/#{link_a}"
# html = open(url)
# doc = Nokogiri::HTML(html)
