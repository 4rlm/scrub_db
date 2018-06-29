# ScrubDb
#### Scrub your database, api data, web scraping data, and web form submissions based on your your custom criteria.  Allows for different criteria for different jobs.  Returns detailed reporting to zero-in on your data with ease, efficiency, and greater insight.  Allows for option to pre-format data before scrubbing to also normalize and standardize your data sets, ex uniform URL patterns

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

### I. Usage Overview


#### Step 1: Load Your Scrub Criteria:

##### 1. For String Criteria
```
strings_criteria = {
  pos_criteria: %w[your positive criteria here],
  neg_criteria: %w[your negative criteria here]
}
strings_obj = ScrubDb::Strings.new(strings_criteria)
```

##### 2. For Web Criteria
```
webs_criteria = {
  pos_criteria: %w[your positive criteria here],
  neg_criteria: %w[your negative criteria here]
}
webs_obj = ScrubDb::Webs.new(webs_criteria)
```



#### Step 2: Load Your Data to Scrub:

##### Methods available to scrub data:

##### 1. Scrub URLs:
```
scrub_web_obj = ScrubDb::Webs.new(criteria)
scrubbed_web_hashes = scrub_web_obj.scrub_urls(urls)
```

##### 2. Scrub Strings:
```
strings_obj = ScrubDb::Strings.new(strings_criteria)
scrubbed_strings = strings_obj.scrub_strings(array_of_strings)
```

##### 3. Scrub Proper Strings:
```
strings_obj = ScrubDb::Strings.new(strings_criteria)
scrubbed_prop_strings = strings_obj.scrub_proper_strings(array_of_props)
```


### II. Usage Details

### 1. Scrub Array of URLs:
This is an example of scrubbing auto dealership urls.  We only want URLs based in the US, and paths of the staff.  Most of our URLs are good, but we want to confirm that they all meet our requirements.

### A. Pass in Scrub Criteria
First step is to load your Webs criteria in hash format.  It's not required to enter all the keys below, but for those you are using, each key must be a symbol and be exactly the same as the ones below.  The values must each be an array of strings.

```
criteria = {
      neg_urls: %w[aprov avis budget collis eat],
      pos_urls: %w[acura audi bmw bentley],
      neg_paths: %w[buy bye call cash cheap click collis cont distrib],
      pos_paths: %w[team staff management],
      neg_exts: %w[au ca edu es gov in ru uk us],
      pos_exts: %w[com net]
    }

scrub_web_obj = ScrubDb::Webs.new(criteria)
```

### B. Pass in URLs List

Next, pass your list of URLs to `scrub_urls(urls)` with the syntax below.

```
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

scrubbed_web_hashes = scrub_web_obj.scrub_urls(urls)
```

### C. Returned Results
Notice that the URLs in the list above are NOT uniformly formatted.  ScrubDb leverages the `Utf8Sanitizer gem` and `CrmFormatter gem` to first format the URLs.  Then, it passes the formatted URL hashes to be scrubbed based on the criteria passes in earlier.  The results will be returned in the syntax below:

```
scrubbed_web_hashes = [
  {
    web_status: 'invalid',
    url: 'austinchevrolet.not.real',
    url_f: nil,
    url_path: nil,
    web_neg: 'error: ext.invalid [not, real]',
    url_exts: [],
    neg_exts: [],
    pos_exts: [],
    neg_paths: [],
    pos_paths: [],
    neg_urls: [],
    pos_urls: []
  },
  { web_status: 'formatted',
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
  { web_status: 'formatted',
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
  { web_status: 'formatted',
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
  { web_status: 'formatted',
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
  { web_status: 'formatted',
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
  { web_status: 'formatted',
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
  { web_status: 'formatted',
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
  { web_status: 'invalid',
    url: 'www.mitsubishideals.sofake',
    url_f: nil,
    url_path: nil,
    web_neg: 'error: ext.invalid [sofake]',
    url_exts: [],
    neg_exts: [],
    pos_exts: [],
    neg_paths: [],
    pos_paths: [],
    neg_urls: [],
    pos_urls: []
  },
  { web_status: 'formatted',
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
  { web_status: 'formatted',
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
  { web_status: 'formatted',
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
  { web_status: 'invalid',
    url: 'www.www.nissancars/inventory',
    url_f: nil,
    url_path: nil,
    web_neg: 'error: ext.none',
    url_exts: [],
    neg_exts: [],
    pos_exts: [],
    neg_paths: [],
    pos_paths: [],
    neg_urls: [],
    pos_urls: []
  },
  { web_status: 'formatted',
    url: 'www.www.toyotatown.net/staff/management',
    url_f: 'http://www.toyotatown.net',
    url_path: '/staff/management',
    web_neg: nil,
    url_exts: ['net'],
    neg_exts: [],
    pos_exts: ['net'],
    neg_paths: [],
    pos_paths: ['management, staff'],
    neg_urls: [],
    pos_urls: ['toyota']
  },
  { web_status: 'formatted',
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


### 2. Scrub Array of Strings:

You can scrub an array of strings with or without formatting.
For scrubbing proper strings (account and business names, job titles, article titles, brands, locations, etc.) like below, you might prefer the proper scrub method, but these examples will use the same criteria and same array of strings to illustrate the difference.

Continuing with the auto dealership example above, the following examples are to scrub the auto dealership account names.  We want to prioritize our data based on those who match our positive criteria, those who match our negative criteria, and those who are neutral.

### A. Pass in Scrub Criteria
First step is to load your Strings criteria in hash format.  It's not required to enter all the keys below, but for those you are using, each key must be a symbol and be exactly the same as the ones below.  The values must each be an array of strings.

```
strings_criteria = {
      neg_urls: %w[aprov avis budget collis eat],
      pos_urls: %w[acura audi bmw bentley],
      neg_paths: %w[buy bye call cash cheap click collis cont distrib],
      pos_paths: %w[team staff management],
      neg_exts: %w[au ca edu es gov in ru uk us],
      pos_exts: %w[com net]
    }

strings_obj = ScrubDb::Strings.new(strings_criteria)
```

### B. Pass in Strings List

Next, pass your list of strings to `scrub_strings(strings)` with the syntax below.

```
array_of_strings = [
  'quick auto approval, inc',
  'the gmc and bmw-world of AUSTIN tx',
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

scrubbed_strings = strings_obj.scrub_strings(array_of_strings)
```

### C. Returned Results

```
scrubbed_strings = [
  {
   string: 'quick auto approval, inc',
   pos_criteria: [],
   neg_criteria: ['approv, quick']
  },
  {
   string: 'the gmc and bmw-world of AUSTIN tx',
   pos_criteria: ['bmw, gmc'],
   neg_criteria: []
  },
  {
   string: 'DOWNTOWN CAR REPAIR, INC',
   pos_criteria: [],
   neg_criteria: ['repair']
  },
  {
   string: 'TEXAS TRAVEL, CO',
   pos_criteria: [],
   neg_criteria: ['travel']
  },
  {
   string: '123 Car-world Kia OF CHICAGO IL',
   pos_criteria: ['kia'],
   neg_criteria: []
  },
  {
   string: 'Main Street Ford in DALLAS tX',
   pos_criteria: ['ford'],
   neg_criteria: []
  },
  {
   string: 'broad st fiat of houston',
   pos_criteria: ['fiat'],
   neg_criteria: []
  },
  {
   string: 'hot-deal auto insurance',
   pos_criteria: [],
   neg_criteria: ['insur']
  },
  {
   string: 'BUDGET - AUTOMOTORES ZONA & FRANCA, INC',
   pos_criteria: [],
   neg_criteria: ['budget']
  },
  {
   string: 'Young Gmc Trucks',
   pos_criteria: ['gmc'],
   neg_criteria: []
  },
  {
   string: 'youmans Chevrolet',
   pos_criteria: ['chevrolet'],
   neg_criteria: []
  },
  {
   string: 'yazell chevy',
   pos_criteria: [],
   neg_criteria: []
  },
  {
   string: 'quick cAr LUBE',
   pos_criteria: [],
   neg_criteria: ['lube, quick']
  },
  {
   string: 'yAtEs AuTo maLL',
   pos_criteria: [],
   neg_criteria: []
  },
  {
   string: 'YADKIN VALLEY COLLISION CO',
   pos_criteria: [],
   neg_criteria: ['collis']
  },
  {
   string: 'XIT FORD INC',
   pos_criteria: ['ford'],
   neg_criteria: []
  }
]
```


### 3. Scrub Array of Proper Strings:
This method is designed for scrubbing proper strings, like account and business names, job titles, article titles, brands, locations, etc.

This method is identical to example 2 above (Scrub Array of Strings), except this method first formats the strings using the `Utf8Sanitizer gem` and `CrmFormatter gem`, then passes the results to the method above to scrub.  So, this is a 2-in-1 method, Format + Scrub! Again, this method treats your strings as if they are proper nouns, so compare the results of these two methods to determine which is most suitable for your data.

### A. Pass in Scrub Criteria
First step is to load your Strings criteria in hash format.  It's not required to enter all the keys below, but for those you are using, each key must be a symbol and be exactly the same as the ones below.  The values must each be an array of strings.

```
strings_criteria = {
      neg_urls: %w[aprov avis budget collis eat],
      pos_urls: %w[acura audi bmw bentley],
      neg_paths: %w[buy bye call cash cheap click collis cont distrib],
      pos_paths: %w[team staff management],
      neg_exts: %w[au ca edu es gov in ru uk us],
      pos_exts: %w[com net]
    }

strings_obj = ScrubDb::Strings.new(strings_criteria)
```

### B. Pass in Strings List

Next, pass your list of strings to `scrub_proper_strings(strings)` with the syntax below.

```
array_of_strings = [
  'quick auto approval, inc',
  'the gmc and bmw-world of AUSTIN tx',
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

scrubbed_proper_strings = strings_obj.scrub_proper_strings(array_of_strings)
```

### C. Returned Results

```
scrubbed_proper_strings = [
    {
      proper_status: 'formatted',
      proper: 'quick auto approval, inc',
      proper_f: 'Quick Auto Approval, Inc',
      pos_criteria: [],
      neg_criteria: ['approv, quick']
    },
    {
      proper_status: 'formatted',
      proper: 'the gmc and bmw-world of AUSTIN tx',
      proper_f: 'The GMC and BMW-World of Austin TX',
      pos_criteria: ['bmw, gmc'],
      neg_criteria: []
    },
    {
      proper_status: 'formatted',
      proper: 'DOWNTOWN CAR REPAIR, INC',
      proper_f: 'Downtown Car Repair, Inc',
      pos_criteria: [],
      neg_criteria: ['repair']
    },
    {
      proper_status: 'formatted',
      proper: 'TEXAS TRAVEL, CO',
      proper_f: 'Texas Travel, Co',
      pos_criteria: [],
      neg_criteria: ['travel']
    },
    {
      proper_status: 'formatted',
      proper: '123 Car-world Kia OF CHICAGO IL',
      proper_f: '123 Car-World Kia of Chicago IL',
      pos_criteria: ['kia'],
      neg_criteria: []
    },
    {
      proper_status: 'formatted',
      proper: 'Main Street Ford in DALLAS tX',
      proper_f: 'Main Street Ford in Dallas TX',
      pos_criteria: ['ford'],
      neg_criteria: []
    },
    {
      proper_status: 'formatted',
      proper: 'broad st fiat of houston',
      proper_f: 'Broad St Fiat of Houston',
      pos_criteria: ['fiat'],
      neg_criteria: []
    },
    {
      proper_status: 'formatted',
      proper: 'hot-deal auto insurance',
      proper_f: 'Hot-Deal Auto Insurance',
      pos_criteria: [],
      neg_criteria: ['insur']
    },
    {
      proper_status: 'formatted',
      proper: 'BUDGET - AUTOMOTORES ZONA & FRANCA, INC',
      proper_f: 'Budget - Automotores Zona & Franca, Inc',
      pos_criteria: [],
      neg_criteria: ['budget']
    },
    {
      proper_status: 'formatted',
      proper: 'Young Gmc Trucks',
      proper_f: 'Young GMC Trucks',
      pos_criteria: ['gmc'],
      neg_criteria: []
    },
    {
      proper_status: 'formatted',
      proper: 'youmans Chevrolet',
      proper_f: 'Youmans Chevrolet',
      pos_criteria: ['chevrolet'],
      neg_criteria: []
    },
    {
      proper_status: 'formatted',
      proper: 'yazell chevy',
      proper_f: 'Yazell Chevy',
      pos_criteria: [],
      neg_criteria: []
    },
    {
      proper_status: 'formatted',
      proper: 'quick cAr LUBE',
      proper_f: 'Quick Car Lube',
      pos_criteria: [],
      neg_criteria: ['lube, quick']
    },
    {
      proper_status: 'formatted',
      proper: 'yAtEs AuTo maLL',
      proper_f: 'Yates Auto Mall',
      pos_criteria: [],
      neg_criteria: []
    },
    {
      proper_status: 'formatted',
      proper: 'YADKIN VALLEY COLLISION CO',
      proper_f: 'Yadkin Valley Collision Co',
      pos_criteria: [],
      neg_criteria: ['collis']
    },
    {
      proper_status: 'formatted',
      proper: 'XIT FORD INC',
      proper_f: 'Xit Ford Inc',
      pos_criteria: ['ford'],
      neg_criteria: []
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
