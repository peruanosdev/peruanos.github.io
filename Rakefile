# coding: utf-8
require 'jekyll'
require_relative 'lib/meetup_data_extractor.rb'

task :prepare do
    puts 'Preparing data...'.bold
    Download_data::Generator.new.generate()
end

task :build do
puts 'Building site...'.bold
    Jekyll::Commands::Build.process(profile: true)
end