require 'nokogiri'
require 'open-uri'

def scrape_urls
  pages_urls = []
  i = 0
  until i == 2 do
    pages_url = "https://www.discogs.com/search/?sort=hot%2Cdesc&style_exact=Techno&ev=gs_ms&page=#{i += 1}"
    pages_urls << pages_url
  end
  tracks_urls = []
  pages_urls.each do |pages_url|
    html = open(pages_url)
    doc = Nokogiri::HTML(html)
    tracks = doc.css('.card>a')
    tracks.each do |track|
      url = track.attribute('href').value
      tracks_urls << url
    end
    scrape_techno(tracks_urls)
  end
end

def scrape_techno(tracks_urls)
  techno_tracks = []
  tracks_urls.each do |tracks_url|
    url = "https://www.discogs.com/#{tracks_url}"
    html = open(url)
    doc = Nokogiri::HTML(html)
    artist = doc.css('#profile_title>span>span').text.gsub("\n", "").gsub("  ", "")
    title = doc.css('#profile_title>span:nth-child(2n)').text.gsub("\n", "").gsub("  ", "")


    photo_urls = []
    photo_links =

    video_urls = []
    video_links =

    tracks_info = {
      title: title,
      artist: artist,
      # photo_link: photo_link,
      # video_link: video_link
    }
    techno_tracks << tracks_info
  end
end

scrape_urls
