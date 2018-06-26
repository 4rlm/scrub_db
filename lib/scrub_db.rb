require "scrub_db/version"
require 'scrub_db/web'
require 'scrub_db/filter'
require 'pry'

module ScrubDb

  def self.welcome
    puts "Welcome to the gem!"
  end

  # def self.scrub_urls(criteria=[], )
  #   # criteria = args.fetch(:criteria, [])
  #   data = args.fetch(:data, [])
  #   # filter = ScrubDb::Filter.new(criteria)
  #   web_obj = self::Web.new(criteria)
  #   samp = web_obj.welcome(data)
  # end

end
