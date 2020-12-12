require 'nokogiri'
require 'open-uri'
require 'openssl'

def scrape_urls_lbc
  url = "https://www.leboncoin.fr/_immobilier_/offres"
  html = open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE,
    'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_0_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36',
    'Accept:' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'Accept-Language:' => 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
    'Accept-Encoding' => 'gzip, deflate, br',
    'Referer' => 'https://www.google.com/')
  doc = Nokogiri::HTML(html)
  p doc
end

def scrape_urls_slo
  url = "https://www.seloger.com/list.htm?tri=initial&enterprise=0&idtypebien=1&div=2238&idtt=2,5&naturebien=1,2,4&m=search_hp_new"
  html = open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE,
    'User-Agent' => 'Chrome/87.0.4280.88',
    'Accept:' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'Accept-Language:' => 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
    'Accept-Encoding' => 'gzip, deflate, br',)
  doc = Nokogiri::HTML(html)
  p doc
end

def scrape_urls_test
  url = "http://localhost:8000/"
  html = open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE,
    'User-Agent' => 'Chrome/87.0.4280.88',
    'Accept:' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'Accept-Language:' => 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7',
    'Accept-Encoding' => 'gzip, deflate, br',)
  doc = Nokogiri::HTML(html)
  p doc
end

scrape_urls_slo
