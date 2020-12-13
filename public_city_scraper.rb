require 'nokogiri'
require 'open-uri'

def scrape_urls
  pages_urls = []
  i = 0
  until i == 34 do
    pages_url = "https://www.emploi-collectivites.fr/esp_entreprises/annuaire_entreprises/mairie-collectivite-searchresult.asp?motclef=&qu=A&regID=-1&Page=#{i += 1}"
    pages_urls << pages_url
  end
  mairies_urls = []
  pages_urls.each do |pages_url|
    html = open(pages_url)
    doc = Nokogiri::HTML(html)
    mairies = doc.css('.line').search('td:nth-child(n)').css('.fontBlue>a')
    mairies.each do |mairie|
      url = mairie.attribute('href').value
      mairies_urls << url
    end
  end
  scrape_mail(mairies_urls)
end

def scrape_mail(mairies_urls)
  mairies_mails = []
  mairies_urls.each do |mairies_url|
    url = "#{mairies_url}"
    html = open(url)
    doc = Nokogiri::HTML(html)
    td = doc.css('.mairieTable').search(':nth-child(n)').search('td:nth-child(n)').text
    if td.include?('email')
      first_s = td.split('email :')
      second_s = first_s[1].split('Region')
      mail = second_s[0]
    else
      mail = 'Mail not included'
    end
    mairies_mails << mail
  end
  p mairies_mails
end

scrape_urls
