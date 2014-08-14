require 'nokogiri'
require 'open-uri'
require 'date'

module PearlEpgToXmltv

  class Scraper

    # Gets the listing
    def scrape!
      listings = []
      channel = Channel.new
      input = Nokogiri::HTML( data )
      date = input.css('ul').attr('date').to_s # 2014-08-16
      input.css('li.item').each do |xml|
        listings << Listing.from_xml(channel, xml, date)
      end
      out = Tv.to_xml do
        listings_xml = listings.map(&:to_xml).join("\n")
        [channel.to_xml, listings_xml].join("\n")
      end
      File.open('xmltv.xml', 'w') { |f| f.puts out }
    end

    private
    
    def data
      # curl "http://programme.tvb.com/ajax.php?action=channellist&code=P&date=2014-08-16 -H 'Accept-Language: en-GB,en-US;q=0.8,en;q=0.6'"
      # curl "http://programme.tvb.com/ajax.php?action=channellist&code=P&date=2014-08-16"
      date = '2014-08-16'
      url = "http://programme.tvb.com/ajax.php?action=channellist&code=P&date=#{date}"
      #@data = open(url)
      #File.open('epg.html', 'w') { |f| f.puts @data.read }
      #@data.read
      File.open('epg-test.html').read
    end

  end
  
  # <channel id="3sat.de">
  #  <display-name lang="de">3SAT</display-name>
  # </channel>
  class Channel
    attr :id, :name_en, :name_zhtw, :icon
    
    def initialize(options = {})
      @id = 'pearl.tvb.com'
      @name_en = 'Pearl'
      @name_zhtw = ''
    end
    
    def to_xml
      <<XML
<channel id="#{@id}">
    <display-name lang="en">#{name_en}</display-name>
    <display-name lang="zh_TW">#{name_zhtw}</display-name>
  </channel>
XML
    end
    
  end
  
  # <programme start="200006031633" channel="3sat.de">
  #   <title lang="de">blah</title>
  #   <title lang="en">blah</title>
  #   <desc lang="de">Blah Blah Blah.</desc>
  # </programme>
  # iso8601 dates with utc offset "19880523083000 +0800"
  class Listing
    
    attr :start, :channel, :title, :desc
    
    def initialize(options = {})
      @channel = options[:channel]
      @start = options[:start]
      @title = options[:title]
      @desc = options[:desc]
    end
    
    def start_iso8601
      @start = @start + 1 if @start.to_time.hour < 6
      @start.strftime('%Y%m%d%I%M %z')
    end
    
    def title_en
      title #TODO
    end
    
    def title_zhtw
      title # TODO
    end
    
    def to_xml
      <<XML
<programme start="#{start_iso8601}" channel="#{channel.id}">
  <title lang="en">#{title_en}</title>
  <title lang="zh_TW">#{title_zhtw}</title>
  <desc lang="en">#{desc}</desc>
</programme>
XML
    end
    
    # Takes an xml input listing and turns it into a class instance
    def self.from_xml(channel, listing, date)
      # DateTime.strptime('2014-08-16 04:05PM +0800', '%Y-%m-%d %I:%M%p %z')
      time = listing.css('span.time').inner_html #03:30AM
      start = DateTime.strptime("#{date} #{time} +0800", '%Y-%m-%d %I:%M%p %z')
      new( channel: channel,
           start: start,
           title: listing.css(".ftit text()").to_s.strip,
           desc: "Description"
      )
    end
    
  end
  
  # Root XML element
  # <tv generator-info-name="my listings generator">...</tv>
  class Tv
    def self.to_xml(&block)
      <<XML
<tv generator-info-name="pearl_epg_to_xmltv">
  #{yield}
</tv>
XML
    end
  end

end

scraper = PearlEpgToXmltv::Scraper.new
scraper.scrape!
