require 'nokogiri'
require 'open-uri'

def scrape_urls
  url = "https://www.capdel.fr/seminaire-dentreprise"
  html = open(url)
  doc = Nokogiri::HTML(html)
  sem_links = []
  sem = doc.css('.info-wrap')
  sem.each do |s|
      link = s.attribute('href').value
      sem_links << link
    end
  scrape_sem(sem_links)
end


def scrape_sem(sem_links)
  sems = []
  sem_links.each do |sem_link|
    url = "https://www.capdel.fr/#{sem_link}"
    html = open(url)
    doc = Nokogiri::HTML(html)
    category = doc.css(".category-title").text
    title = doc.css(".title").text
    details = doc.css(".details").text

    if_pin = doc.css(".details").search("li").search(".icon-pin")
    if_timer = doc.css(".details").search("li").search(".icon-timer")
    if_person = doc.css(".details").search("li").search(".icon-person")
    if_calendar = doc.css(".details").search("li").search(".icon-calendar")
    if_language = doc.css(".details").search("li").search(".icon-language")

    loc = doc.css(".details>:first-child").text

    duration = doc.css(".details>:nth-child(2)").text
    if_timer.empty? ? duration = "Durée à confirmer" : duration = duration

    person1 = doc.css(".details>:nth-child(2)").text
    person2 = doc.css(".details>:nth-child(3)").text
    if_timer.empty? ? person = person1 : person = person2

    period1 = doc.css(".details>:nth-child(3)").text
    period2 = doc.css(".details>:nth-child(4)").text
    if_timer.empty? ? period = period1 : period = period2

    lang1 = doc.css(".details>:nth-child(4)").text
    lang2 = doc.css(".details>:nth-child(5)").text
    if_timer.empty? ? lang = lang1 : lang = lang2

    p lang
  end
end

scrape_urls
