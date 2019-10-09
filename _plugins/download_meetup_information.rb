require 'json'
require 'net/http'
require 'uri'
require 'nokogiri'

module Download_data
  class Generator < Jekyll::Generator

    def is_meetup_uri?(uri)
      uri_pattern = /meetup.com/
      match = uri_pattern.match(uri)
      return match != nil
    end

    def getPlainText(input)
      parsed = Nokogiri::HTML(input)
      return parsed.text.strip
    end

    def get_meetup_data(uri)
        if is_meetup_uri?(uri)
            uri_pattern = /.+\/(?<uri_name>[\w\-]+).*/
            match = uri_pattern.match(uri)
            if !(match)
                raise 'malformed meetup uri: ' + uri
            end
            request_uri  = "https://api.meetup.com/#{match[:uri_name]}"
            encoded_uri = URI.encode(request_uri)
            meetup_uri = URI.parse(encoded_uri)
            puts "Getting Meetup Data from #{uri}"
            response = Net::HTTP.get_response(meetup_uri)
            #Return Naked response
            meetup_data = JSON.parse(response.body)
            meetup_data['description'] = getPlainText(meetup_data['description'])
            return meetup_data
        end
    end

    def generate(site)
    #WIll generate a map[url, meetup_data]
      puts "Generating url map"
      if(File.exist?('_data/results.json'))
        puts "results.json file already exists"
        return
      end
      communities_array = site.data['communities']
      meetup_data_map = Hash.new
      for community in communities_array
        community_url = community['url']
        meetup_data = get_meetup_data(community_url)
        if(meetup_data)
          meetup_data_map[community_url] = meetup_data
        end
      end
      site.data['results'] = meetup_data_map
      open("_data/results.json", 'wb') do |file|
        file << JSON.generate(meetup_data_map)
      end
      puts "Finished gathering Meetup metadata"
    end
  end
end