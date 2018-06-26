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

  scrubbed_urls = scrub_urls


  binding.pry

  orig_hashes = [{ :row_id=>"1", :url=>"stanleykaufman.com", :act_name=>"Stanley Chevrolet Kaufman\x99_\xCC", :street=>"825 E Fair St", :city=>"Kaufman", :state=>"TX", :zip=>"75142", :phone=>"(888) 457-4391\r\n" }]

  # sanitized_data = Utf8Sanitizer.sanitize(data: orig_hashes)
  # sanitized_data = Utf8Sanitizer.sanitize
  # puts sanitized_data.inspect
  IRB.start
end

def scrub_urls
  data = %w[www.sample01.net.com sample02.com http://www.sample3.net www.sample04.net/contact_us http://sample05.net www.sample06.sofake www.sample07.com.sofake example08.not.real www.sample09.net/staff/management www.www.sample10.com]

  # args = {data: data}
  # args.merge!({criteria: WebCriteria.all_web_criteria})

  web_obj = ScrubDb::Web.new(WebCriteria.all_web_criteria)
  binding.pry

  scrubbed_webs = web_obj.scrub_ext(data)
  binding.pry
end
