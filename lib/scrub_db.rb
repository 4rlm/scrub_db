require "scrub_db/version"
require 'scrub_db/web'
require 'pry'

module ScrubDb

  def self.welcome
    puts "Welcome to the gem!"
  end

  def self.scrub_web
    criteria = { criteria: [] }
    data = { data: [] }

    web_obj = self::Web.new(criteria)
    binding.pry

    samp = web_obj.welcome(data)
    binding.pry

  end

end
