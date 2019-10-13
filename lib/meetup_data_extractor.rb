require 'json'
require 'net/http'
require 'uri'
require 'nokogiri'

module Download_data
  class Generator

    def is_meetup_uri?(uri)
      uri_pattern = /meetup.com/
      match = uri_pattern.match(uri) 
      return match != nil
    end

    def getPlainText(input)
      parsed = Nokogiri::HTML(input)
      return parsed.text.strip
    end

    def get_next_events_data(url_name)
      request_uri  = "https://api.meetup.com/#{url_name}/events"
      encoded_uri = URI.encode(request_uri)
      meetup_events_uri = URI.parse(encoded_uri)

      response = Net::HTTP.get_response(meetup_events_uri)
 
      events_data = JSON.parse(response.body)
      
      return events_data
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
            
            meetup_data = JSON.parse(response.body)

            puts "Getting next events for #{meetup_data['name']}"
            events_data = get_next_events_data(match[:uri_name])
            puts "#{events_data.count} events founded"

            return meetup_data, events_data
        end
    end

    def generate()

      f = File.open("_data/communities.json", "r")

      communities_array = JSON.parse(f.read())
 
      meetup_list = []
      events_list = []
      
      for community in communities_array
        community_url = community['url']
        meetup_data, events_data = get_meetup_data(community_url)
        meetup_list += [meetup_data] if meetup_data
        events_list += events_data if events_data
      end
      
      open("_data/info.json", 'w+') do |info_file|
        info_file << meetup_list.to_json
      end 

      open("_data/events.json", 'w+') do |events_file|
        events_file << events_list.to_json
      end

      puts "Finished gathering Meetup metadata"
    end
  end
end

