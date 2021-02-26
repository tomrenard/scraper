require 'nokogiri'
require 'open-uri'
require 'watir'
require 'webdrivers'

def scrape_location
  urls = []
  locations = ['de/berlin', 'fr/paris', 'fr/west', 'es/barcelona', 'uk/london', 'us/newyork', 'nl/amsterdam',
  'jp/tokyo', 'us/losangeles', 'uk/manchester', 'ca/montreal', 'ru/moscow', 'us/miami', 'es/ibiza', 'de/leipzig',
  'pt/lisbon', 'ie/dublin']
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
      url.include?('event') ? events_urls << url : clubs_urls << url
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
    address = doc.css('.Grid__GridStyled-sc-1l00ugd-0.hTDtOT.grid').css('.Text-sc-1t0gn2o-0.dhoduX').first.text.gsub("\n", '').gsub("\r", '')
    start_date = doc.css('.Text-sc-1t0gn2o-0.Link__StyledLink-k7o46r-0.hvqKqA').last.text.gsub("\n", '').gsub("\r", '')
    info_st_h = doc.css('.Text-sc-1t0gn2o-0.dhoduX').slice(1).text
    reg_h = /^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/
    start_h = info_st_h.match(reg_h)[0]
    info_end_h = doc.css('.Text-sc-1t0gn2o-0.dhoduX').slice(3).text
    end_h = info_end_h.match(reg_h)[0]
    line_up = doc.css('.Text-sc-1t0gn2o-0.CmsContent__StyledText-g7gf78-0').text.gsub("\n", '').gsub("\r", '') #not_correct
    prom = doc.css('.Text-sc-1t0gn2o-0.dhoduX').slice(4).text.gsub("\n", '').gsub("\r", '')
    price = doc.css('.Text-sc-1t0gn2o-0.dhoduX').last.text
    description = doc.css('.Text-sc-1t0gn2o-0.EventDescription__BreakText-a2vzlh-0.hPALEa').text.gsub("\n", '').gsub("\r", '')
    img_urls = []
    img_links = doc.css('.FullWidthStyle-sc-4b98ap-0.htnFjY>img')
    img_links.each do |img_link|
      img_url = img_link.attribute('src').value
      img_urls << img_url.to_s
    end
    event_info = {
      title: title || title2,
      location: address,
      date: start_date,
      start_h: start_h,
      end_h: end_h,
      line_up: line_up,
      promoter: prom,
      description: description || 'Oups, looks like the description is secret or someone was lazy here...',
      photo_link: img_urls[0] || 'https://source.unsplash.com/featured/?nightclub',
      price: price || 'You better take 15 bucks, just in case'
    }
    events << event_info
    p events
  end
end

scrape_location
