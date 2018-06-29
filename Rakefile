require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'scrub_db'
require 'webs_criteria'


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

  # scrubbed_webs = run_scrub_web
  # scrubbed_strings = run_scrub_strings
  scrubbed_proper_strings = run_scrub_proper_strings
  binding.pry

  IRB.start
end


def run_scrub_strings
  ## Using WebsCriteria in Scrub Strings ##
  strings_criteria = {
    pos_criteria: WebsCriteria.seed_pos_urls,
    neg_criteria: WebsCriteria.seed_neg_urls
  }

  strings_obj = ScrubDb::Strings.new(strings_criteria)

  array_of_strings = [
    'bmw-world of austin',
    '123 Car-world Kia OF CHICAGO',
    'BUDGET - AUTOMOTORES ZONA & FRANCA, INC',
    'DOWNTOWN CAR REPAIR, INC',
    'Young Gmc Trucks',
    'TEXAS TRAVEL, CO',
    'youmans Chevrolet',
    'Hot-Deal auto Insurance',
    'quick auto approval, inc',
    'yazell chevy',
    'quick cAr LUBE',
    'yAtEs AuTo maLL',
    'YADKIN VALLEY COLLISION CO',
    'XIT FORD INC'
  ]

  scrubbed_strings = strings_obj.scrub_strings(array_of_strings)
  binding.pry
end


def run_scrub_proper_strings
  ## Using WebsCriteria in Scrub Strings ##
  strings_criteria = {
    pos_criteria: WebsCriteria.seed_pos_urls,
    neg_criteria: WebsCriteria.seed_neg_urls
  }

  strings_obj = ScrubDb::Strings.new(strings_criteria)

  array_of_propers = [
    'bmw-world of austin',
    '123 Car-world Kia OF CHICAGO',
    'BUDGET - AUTOMOTORES ZONA & FRANCA, INC',
    'DOWNTOWN CAR REPAIR, INC',
    'Young Gmc Trucks',
    'TEXAS TRAVEL, CO',
    'youmans Chevrolet',
    'Hot-Deal auto Insurance',
    'quick auto approval, inc',
    'yazell chevy',
    'quick cAr LUBE',
    'yAtEs AuTo maLL',
    'YADKIN VALLEY COLLISION CO',
    'XIT FORD INC'
  ]

  scrubbed_proper_strings = strings_obj.scrub_proper_strings(array_of_propers)
  binding.pry
end



def run_scrub_webs
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

  webs_obj = ScrubDb::Webs.new(WebsCriteria.all_scrub_web_criteria)
  scrubbed_webs = webs_obj.scrub_urls(urls)
end
