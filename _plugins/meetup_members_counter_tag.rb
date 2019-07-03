require 'net/http'
require 'uri'
require 'json'
require 'uri'

module Jekyll
    class MeetupMembersCounterTag < Liquid::Tag
        def initialize(tag_name, text, tokens)
            super
            @meetup_uri = text
        end

        def get_meetup_data(uri)
            uri_pattern = /.+\/(?<uri_name>[\w\-]+).*/
            match = uri_pattern.match(uri)
            if !(match)
                raise 'malformed meetup uri: ' + uri
            end
            request_uri  = "https://api.meetup.com/#{match[:uri_name]}"
            encoded_uri = URI.encode(request_uri)
            meetup_uri = URI.parse(encoded_uri)
            puts "Getting members count from #{uri}"
            response = Net::HTTP.get_response(meetup_uri)
            meetup_data = JSON.parse(response.body)
            return meetup_data
        end

        def render(context)
            uri = context[@meetup_uri] || @meetup_uri
            meetup_data = get_meetup_data(uri)
            return "#{meetup_data["members"]}"
        end
    end
end

Liquid::Template.register_tag('meetup_members_counter', Jekyll::MeetupMembersCounterTag)