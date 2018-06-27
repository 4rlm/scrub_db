require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'scrub_db'
require 'web_criteria'


RSpec::Core::RakeTask.new(:spec)

task :default => :spec
task :test => :spec

###################
task :console do
  require 'irb'
  require 'irb/completion'
  require 'scrub_db'
  require "active_support/all"
  ARGV.clear

  scrubbed_urls = scrub_sample_urls
  binding.pry

  IRB.start
end

def scrub_sample_urls
  urls = %w[
    smith_acura.com/staff
    abcrepair.ca
    austinchevrolet.not.real
    hertzrentals.com/review
    londonhyundai.uk/fleet
    http://www.townbuick.net/staff
    http://youtube.com/download
    www.madridinfiniti.es/collision
    www.mitsubishideals.sofake
    www.dallassubaru.com.sofake
    www.quickeats.net/contact_us
    www.school.edu/teachers
    www.www.nissancars/inventory
    www.www.toyotatown.net/staff/management
    www.www.yellowpages.com/business
  ]

  web_obj = ScrubDb::Web.new(WebCriteria.all_web_criteria)
  scrubbed_webs = web_obj.scrub_urls(urls)
end
