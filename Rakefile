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

  # scrubbed_webs = run_scrub_webs
  # scrubbed_proper_strings = run_scrub_proper_strings
  # scrubbed_strings = run_scrub_strings
  scrubbed_hash = run_scrub_string
  binding.pry
  scrubbed_hash = run_scrub_proper_string
  binding.pry

  IRB.start
end


def run_scrub_string
  strings_criteria = {
    pos_criteria: WebsCriteria.seed_pos_urls,
    neg_criteria: WebsCriteria.seed_neg_urls
  }
  string = 'quick auto-approval gmc and bmw-world of AUSTIN tx, INC'
  strings_obj = ScrubDb::Strings.new(strings_criteria)
  scrubbed_hash = strings_obj.scrub_string(string)
end


def run_scrub_proper_string
  strings_criteria = {
    pos_criteria: WebsCriteria.seed_pos_urls,
    neg_criteria: WebsCriteria.seed_neg_urls
  }
  string = 'quick auto-approval gmc and bmw-world of AUSTIN tx, INC'
  strings_obj = ScrubDb::Strings.new(strings_criteria)
  scrubbed_hash = strings_obj.scrub_proper_string(string)
end


def run_scrub_strings
  strings_criteria = {
    pos_criteria: WebsCriteria.seed_pos_urls,
    neg_criteria: WebsCriteria.seed_neg_urls
  }

  array_of_strings = [
    'quick auto-approval gmc and bmw-world of AUSTIN tx, INC',
    'quick auto-approval, inc',
    'DOWNTOWN CAR REPAIR, INC',
    'TEXAS TRAVEL, CO',
    '123 Car-world Kia OF CHICAGO IL',
    'Main Street Ford in DALLAS tX',
    'broad st fiat of houston',
    'hot-deal auto insurance',
    'BUDGET - AUTOMOTORES ZONA & FRANCA, INC',
    'Young Gmc Trucks',
    'youmans Chevrolet',
    'yazell chevy',
    'quick cAr LUBE',
    'yAtEs AuTo maLL',
    'YADKIN VALLEY COLLISION CO',
    'XIT FORD INC'
  ]

  strings_obj = ScrubDb::Strings.new(strings_criteria)
  scrubbed_strings = strings_obj.scrub_strings(array_of_strings)
end


def run_scrub_proper_strings
  strings_criteria = {
    pos_criteria: WebsCriteria.seed_pos_urls,
    neg_criteria: WebsCriteria.seed_neg_urls
  }

  array_of_strings = [
    'quick auto-approval gmc and bmw-world of AUSTIN tx, INC',
    'quick auto-approval, inc',
    'DOWNTOWN CAR REPAIR, INC',
    'TEXAS TRAVEL, CO',
    '123 Car-world Kia OF CHICAGO IL',
    'Main Street Ford in DALLAS tX',
    'broad st fiat of houston',
    'hot-deal auto insurance',
    'BUDGET - AUTOMOTORES ZONA & FRANCA, INC',
    'Young Gmc Trucks',
    'youmans Chevrolet',
    'yazell chevy',
    'quick cAr LUBE',
    'yAtEs AuTo maLL',
    'YADKIN VALLEY COLLISION CO',
    'XIT FORD INC'
  ]

  strings_obj = ScrubDb::Strings.new(strings_criteria)
  scrubbed_proper_strings = strings_obj.scrub_proper_strings(array_of_strings)
end


def run_scrub_webs
  urls = %w[
    austinchevrolet.not.real
    smith_acura.com/staff
    abcrepair.ca
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
