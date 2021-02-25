require 'nokogiri'
require 'open-uri'
require 'watir'
require 'webdrivers'

def scrape_location
  urls = []
  locations = ['de/berlin', 'es/barcelona', 'uk/london', 'us/newyork', 'nl/amsterdam', 'jp/tokyo',
    'us/losangeles', 'us/miami', 'es/ibiza', 'pt/lisbon', 'ie/dublin']

  locations.each do |location|
    date = Date.today
    dates = [date, date + 7, date + 14, date + 21]
    dates.each do |date|
      url = "https://ra.co/events/#{location}?week=#{date}"
      urls << url
    end
  end
  scrape_event_url(urls)
end

def scrape_event_url(urls)
  urls.each do |url|
    browser = Watir::Browser.new
    browser.goto(url)
    html = (open(browser.url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE, 'User-Agent' => 'opera'))
    doc = Nokogiri::HTML(html)
    links = doc.css('.Box-omzyfs-0.sc-AxjAm.kOicxR').search('a')
    events_urls = []
    clubs_urls = []
    links.each do |link|
      url = link.attribute('href').value
      if url.include?('event')
        events_urls << url
      else
        clubs_urls << url
      end
    end
    scrape_event_content(events_urls)
    browser.close
  end
end

def scrape_event_content(events_urls)
  events = []
  events_urls.each do |events_url|
    url = "https://ra.co/#{events_url}"
    html = (open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE, 'User-Agent' => 'opera'))
    doc = Nokogiri::HTML(html)
    title = doc.css('.Text-sc-1t0gn2o-0.lYqGv').text.gsub("\n", '').gsub("\r", '')
    title2 = doc.css('.Text-sc-1t0gn2o-0.llxwqv').text.gsub("\n", '').gsub("\r", '')
    address = doc.css('.Grid__GridStyled-sc-1l00ugd-0.hTDtOT.grid').css('.Text-sc-1t0gn2o-0.dhoduX').first.text.gsub("\n", '').gsub("\r", '') # good
    starting_date = doc.css('.Text-sc-1t0gn2o-0.Link__StyledLink-k7o46r-0.hvqKqA').last.text.gsub("\n", '').gsub("\r", '') # good
    line_up = doc.css('.Text-sc-1t0gn2o-0.CmsContent__StyledText-g7gf78-0').text.gsub("\n", ' ').gsub("\r", ' ') # good
    promoter = doc.css('.Text-sc-1t0gn2o-0.dhoduX').slice(4).text.gsub("\n", '').gsub("\r", '') #good but not reliable ?
    price = doc.css('.Text-sc-1t0gn2o-0.dhoduX').last.text
    description = doc.css('.Text-sc-1t0gn2o-0.EventDescription__BreakText-a2vzlh-0.hPALEa').text.gsub("\n", '').gsub("\r", '')
    img_urls  = []
    img_links = doc.css('.FullWidthStyle-sc-4b98ap-0.htnFjY>img')
    img_links.each do |img_link|
      img_url = img_link.attribute('src').value
      img_urls << "#{img_url}"
    end

    event_info = {
      location: address,
      date: starting_date,
      line_up: line_up,
      promoter: promoter,
      price: price
    }

    img_urls[0].nil? ? event_info[:photo_link] = 'https://source.unsplash.com/featured/?nightclub' : event_info[:photo_link] = img_urls[0]
    description == '' ? event_info[:description] = 'Oups, looks like the description is secret or someone was lazy here...' : event_info[:description] = description
    title.nil? || title == '' ? event_info[:title] = title2 : event_info[:title] = title

    events << event_info
    p events
  end
end

scrape_location
