require 'nokogiri'
require 'open-uri'
require 'watir'
require 'webdrivers'

def scrape_url
  browser = Watir::Browser.new
  browser.goto('https://ra.co/events/de/berlin?week=2021-02-19')
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
  p events_urls
  events_urls.each do |events_url|
    browser = Watir::Browser.new
    browser.goto("https://ra.co/#{events_url}")
    html = (open(browser.url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE, 'User-Agent' => 'opera'))
    doc = Nokogiri::HTML(html)
    line_up = doc.css('.Text-sc-1t0gn2o-0.CmsContent__StyledText-g7gf78-0').text
    p title
  end
end

scrape_url
