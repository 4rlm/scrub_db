# ScrubDb
#### Scrub data with your custom criteria.  Returns detailed reporting.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'scrub_db'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scrub_db

## Usage

More methods coming soon.  Currently, Scrub Array of URLs is fully functional.

### 1. Scrub Array of URLs:
This is an example of scrubbing auto dealership urls.  We only want URLs based in the US, and paths of the staff.  Most of our URLs are good, but we want to confirm that they all meet our requirements.

### A. Pass in Scrub Criteria
First step is to load your web criteria in hash format.  It's not required to enter all the keys below, but for those you are using, each key must be a symbol and be exactly the same as the ones below.  The values must each be an array of strings.

```
criteria = {
      neg_urls: %w[pprov avis budget collis eat],
      pos_urls: %w[acura audi bmw bentley],
      neg_paths: %w[buy bye call cash cheap click collis cont distrib],
      pos_paths: %w[team staff management],
      neg_exts: %w[au ca edu es gov in ru uk us],
      pos_exts: %w[com net]
    }

web_obj = ScrubDb::Web.new(criteria)
```

### B. Pass in URLs List
Next, pass your list of URLs to `scrub_urls(urls)` with the syntax below.

```
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

scrubbed_web_hashes = web_obj.scrub_urls(urls)
```

### C. Returned Results
Notice that the URLs in the list above are NOT uniformly formatted.  ScrubDb leverages the `Utf8Sanitizer gem` and `CrmFormatter gem` to first format the URLs.  Then, it passes the formatted URL hashes to be scrubbed based on the criteria passes in earlier.  The results will be returned in the syntax below:

```
scrubbed_web_hashes = [
  {
    web_status: 'formatted',
    url: 'smith_acura.com/staff',
    url_f: 'http://www.smith_acura.com',
    url_path: '/staff',
    web_neg: nil,
    url_exts: ['com'],
    neg_exts: [],
    pos_exts: ['com'],
    neg_paths: [],
    pos_paths: ['staff'],
    neg_urls: [],
    pos_urls: ['acura']
  },
  {
    web_status: 'formatted',
    url: 'abcrepair.ca',
    url_f: 'http://www.abcrepair.ca',
    url_path: nil,
    web_neg: nil,
    url_exts: ['ca'],
    neg_exts: ['ca'],
    pos_exts: [],
    neg_paths: [],
    pos_paths: [],
    neg_urls: ['repair'],
    pos_urls: []
  },
  {
    web_status: 'formatted',
    url: 'hertzrentals.com/review',
    url_f: 'http://www.hertzrentals.com',
    url_path: '/review',
    web_neg: nil,
    url_exts: ['com'],
    neg_exts: [],
    pos_exts: ['com'],
    neg_paths: ['review'],
    pos_paths: [],
    neg_urls: ['hertz, rent'],
    pos_urls: []
  },
  {
    web_status: 'formatted',
    url: 'londonhyundai.uk/fleet',
    url_f: 'http://www.londonhyundai.uk',
    url_path: '/fleet',
    web_neg: nil,
    url_exts: ['uk'],
    neg_exts: ['uk'],
    pos_exts: [],
    neg_paths: ['fleet'],
    pos_paths: [],
    neg_urls: [],
    pos_urls: ['hyundai']
  },
  {
    web_status: 'formatted',
    url: 'http://www.townbuick.net/staff',
    url_f: 'http://www.townbuick.net',
    url_path: nil,
    web_neg: nil,
    url_exts: ['net'],
    neg_exts: [],
    pos_exts: ['net'],
    neg_paths: [],
    pos_paths: [],
    neg_urls: [],
    pos_urls: ['buick']
  },
  {
    web_status: 'formatted',
    url: 'http://youtube.com/download',
    url_f: 'http://www.youtube.com',
    url_path: nil,
    web_neg: nil,
    url_exts: ['com'],
    neg_exts: [],
    pos_exts: ['com'],
    neg_paths: [],
    pos_paths: [],
    neg_urls: ['youtube'],
    pos_urls: []
  },
  {
    web_status: 'formatted',
    url: 'www.madridinfiniti.es/collision',
    url_f: 'http://www.madridinfiniti.es',
    url_path: '/collision',
    web_neg: nil,
    url_exts: ['es'],
    neg_exts: ['es'],
    pos_exts: [],
    neg_paths: ['collis'],
    pos_paths: [],
    neg_urls: [],
    pos_urls: ['infiniti']
  },
  {
    web_status: 'formatted',
    url: 'www.dallassubaru.com.sofake',
    url_f: 'http://www.dallassubaru.com',
    url_path: nil,
    web_neg: nil,
    url_exts: ['com'],
    neg_exts: [],
    pos_exts: ['com'],
    neg_paths: [],
    pos_paths: [],
    neg_urls: [],
    pos_urls: ['subaru']
  },
  {
    web_status: 'formatted',
    url: 'www.quickeats.net/contact_us',
    url_f: 'http://www.quickeats.net',
    url_path: '/contact_us',
    web_neg: nil,
    url_exts: ['net'],
    neg_exts: [],
    pos_exts: ['net'],
    neg_paths: ['cont'],
    pos_paths: [],
    neg_urls: ['eat, quick'],
    pos_urls: []
  },
  {
    web_status: 'formatted',
    url: 'www.school.edu/teachers',
    url_f: 'http://www.school.edu',
    url_path: '/teachers',
    web_neg: nil,
    url_exts: ['edu'],
    neg_exts: ['edu'],
    pos_exts: [],
    neg_paths: [],
    pos_paths: [],
    neg_urls: [],
    pos_urls: []
  },
  {
    web_status: 'formatted',
    url: 'www.www.toyotatown.net/staff/management',
    url_f: 'http://www.toyotatown.net',
    url_path: '/staff/management',
    web_neg: nil,
    url_exts: ['net'],
    neg_exts: [],
    pos_exts: ['net'],
    neg_paths: [],
    pos_paths: ['staff, management'],
    neg_urls: [],
    pos_urls: ['toyota']
  },
  {
    web_status: 'formatted',
    url: 'www.www.yellowpages.com/business',
    url_f: 'http://www.yellowpages.com',
    url_path: '/business',
    web_neg: nil,
    url_exts: ['com'],
    neg_exts: [],
    pos_exts: ['com'],
    neg_paths: ['business'],
    pos_paths: [],
    neg_urls: ['yellowpages'],
    pos_urls: []
  }
]
```


## Author

Adam J Booth  - [4rlm](https://github.com/4rlm)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/4rlm/scrub_db. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ScrubDb project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/4rlm/scrub_db/blob/master/CODE_OF_CONDUCT.md).
