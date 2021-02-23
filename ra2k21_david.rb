require 'nokogiri'
require 'open-uri'
require 'watir'
require 'webdrivers'

def scrape_url
  browser = Watir::Browser.new
  browser.goto('https://ra.co/events/uk/london?week=2021-02-23')
  html = (open(browser.url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE, 'User-Agent' => 'opera'))
  doc = Nokogiri::HTML(html)
  tries = doc.css('.Box-omzyfs-0.sc-AxjAm.kOicxR').search('a')
  events_urls = []
  clubs_urls = []
  tries.each do |try|
    url = try.attribute('href').value
    if url.include?('event')
      events_urls << url
    else
      clubs_urls << url
    end
  end
  scrape_event(events_urls)
end

def scrape_event(events_urls)
  events = []
  events_urls.each do |events_url|
    url = "https://ra.co/#{events_url}"
    html = (open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE, 'User-Agent' => 'opera'))
    doc = Nokogiri::HTML(html)
    title = doc.css('.Text-sc-1t0gn2o-0.llxwqv').text.gsub("\n", '').gsub("\r", '') # good
    location = doc.css('.Grid__GridStyled-sc-1l00ugd-0.hTDtOT.grid').css('.Text-sc-1t0gn2o-0.dhoduX').first.text.gsub("\n", '').gsub("\r", '') # good
    date = doc.css('.Text-sc-1t0gn2o-0.Link__StyledLink-k7o46r-0.hvqKqA').last.text.gsub("\n", '').gsub("\r", '') # good
    line_up = doc.css('.Text-sc-1t0gn2o-0.CmsContent__StyledText-g7gf78-0').text.gsub("\n", ' ').gsub("\r", ' ') # good
    promoter = doc.css('.Text-sc-1t0gn2o-0.dhoduX').slice(4).text.gsub("\n", '').gsub("\r", '') #good but not reliable ?
    price = doc.css('.Text-sc-1t0gn2o-0.dhoduX').last.text
    description = doc.css('.Text-sc-1t0gn2o-0.EventDescription__BreakText-a2vzlh-0.hPALEa').text.gsub("\n", '').gsub("\r", '')

    photo_urls = []
    photo_links = doc.css('.FullWidthStyle-sc-4b98ap-0.htnFjY>img')
    photo_links.each do |photo_link|
      photo_url = photo_link.attribute('src').value
      photo_urls << "#{photo_url}"
    end

    event_info = {
      title: title,
      location: location,
      date: date,
      line_up: line_up,
      promoter: promoter,
      price: price,
      description: description,
      photo_link: photo_urls[0]
    }
    events << event_info
    p events
  end
end

scrape_url
