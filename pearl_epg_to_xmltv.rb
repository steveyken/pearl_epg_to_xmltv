require 'nokogiri'
require 'open-uri'

module PearlEpgToXmltv

  class Scraper

    def initialize(options = {})
      @options = options
    end

    # Gets the listing
    def scrape
      out = []
      data = open( url("2014-08-16") )
      doc = Nokogiri::HTML(data)
      doc.css('li.item').each do |listing|
        out << listing.css('span.time').inner_html
      end
      out
    end

    private

    # puts url.call("2014-08-16")
    def url(date)
      # curl "http://programme.tvb.com/ajax.php?action=channellist&code=P&date=2014-08-16 -H 'Accept-Language: en-GB,en-US;q=0.8,en;q=0.6'"
      # curl "http://programme.tvb.com/ajax.php?action=channellist&code=P&date=2014-08-16"
      "http://programme.tvb.com/ajax.php?action=channellist&code=P&date=#{date}"
    end

  end

end

scraper = PearlEpgToXmltv::Scraper.new()
puts scraper.scrape
