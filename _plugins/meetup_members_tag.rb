require 'net/http'
require 'uri'
require 'json'

module Jekyll
    class MeetupMembersCounterTag < Liquid::Tag
        def initialize(tag_name, text, tokens)
            super
            @meetup_uri = text
        end

        def get_meetup_data(uri)
            uri_pattern = /.+\/(?<uri_name>[^\/]+)/
            meetup_name = uri_pattern.match(uri)["uri_name"]
            meetup_uri  = "https://api.meetup.com/#{meetup_name}"
            response = Net::HTTP.get_response(uri)
            meetup_data = JSON.parse(response.body)
            return meetup_data
        end

        def render(context)
            meetup_data = get_meetup_data(@meetup_uri)
            return "#{@meetup_data["members"]}"
        end
    end
end

Liquid::Template.register_tag('meetup_members_counter', Jekyll::MeetupMembersCounterTag)