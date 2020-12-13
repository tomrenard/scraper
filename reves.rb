require 'nokogiri'
require 'open-uri'
require 'mechanize'

def scrape_urls
  pages_urls = []
  url = "https://www.capdel.fr/voyage-incentive?n=voyage-incentive"
  agent = Mechanize.new
  page = agent.get(url)
  loop do
    lien = page.link_with(:text => ' › Next ') || page.link_with(:text => " › ›› ")
    break unless lien
    next_page_url = lien.uri.to_s
    pages_urls << next_page_url
    page = lien.click
  end
  inc_links = []
  pages_urls.each do |pages_url|
    html = open(url)
    doc = Nokogiri::HTML(html)
    inc = doc.css('.info-wrap')
    inc.each do |s|
      link = s.attribute('href').value
      inc_links << link
    end
  end
  scrape_sem(inc_links)
end

def scrape_sem(inc_links)
  incs = []
  inc_links.each do |sem_link|
    url = "https://www.capdel.fr/#{sem_link}"
    html = open(url)
    doc = Nokogiri::HTML(html)
    category = doc.css(".category-title").text.lstrip
    title = doc.css(".title").text.lstrip
    details = doc.css(".details").text.lstrip
    if_timer = doc.css(".details").search("li").search(".icon-timer")
    loc = doc.css(".details>:first-child").text.lstrip
    duration = doc.css(".details>:nth-child(2)").text
    if_timer.empty? ? duration = "Durée à confirmer" : duration = duration.lstrip
    person1 = doc.css(".details>:nth-child(2)").text.lstrip
    person2 = doc.css(".details>:nth-child(3)").text.lstrip
    if_timer.empty? ? person = person1 : person = person2
    period1 = doc.css(".details>:nth-child(3)").text.lstrip
    period2 = doc.css(".details>:nth-child(4)").text.lstrip
    if_timer.empty? ? period = period1 : period = period2
    lang1 = doc.css(".details>:nth-child(4)").text.lstrip
    lang2 = doc.css(".details>:nth-child(5)").text.lstrip
    if_timer.empty? ? lang = lang1 : lang = lang2
    description = doc.css(".description-text").text.lstrip
    pros = doc.css(".card-body>p").text.lstrip
    pic_url = "https://source.unsplash.com/1600x900/?#{loc},monument"
    incentive_info = {
      category: category,
      title: title,
      loc: loc,
      duration: duration,
      person: person,
      period: period,
      lang: lang,
      description: description,
      pic_url: pic_url
    }
    incs << incentive_info
  end
end

scrape_urls
