# frozen_string_literal: true

require 'net/http'
require 'uri'

module Jekyll
  class ContributorsTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
    end

    def getContributors
      uri = URI.parse('https://api.github.com/repos/peruanosdev/peruanos.github.io/contributors')
      response = Net::HTTP.get_response(uri)

      contributors = JSON.parse(response.body)
      contributors
    end

    def render(_context)
      contributors = getContributors

      element = "<div class='contributors scrollbar'>"
      contributors.each do |contributor|
        element += "<div class='contributor'>"
        element += "    <a href='#{contributor['html_url']}' title='#{contributor['title']}'>"
        element += "        <img class='User__image' src='#{contributor['avatar_url']}'>"
        element += '    </a>'
        element += '</div>'
      end
      element += '</div>'
      element
    end
  end
end

Liquid::Template.register_tag('contributors', Jekyll::ContributorsTag)
