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
            meetup_name = uri_pattern.match(uri)[:uri_name]
            request_uri  = "https://api.meetup.com/#{meetup_name}"
            encoded_uri = URI.encode(request_uri)
            meetup_uri = URI.parse(encoded_uri)
            response = Net::HTTP.get_response(meetup_uri)
            meetup_data = JSON.parse(response.body)
            return meetup_data
        end

        def render(context)
            meetup_data = get_meetup_data(@meetup_uri)
            return "#{meetup_data["members"]}"
        end
    end
end

Liquid::Template.register_tag('meetup_members_counter', Jekyll::MeetupMembersCounterTag)