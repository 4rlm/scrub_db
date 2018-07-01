
# rspec spec/scrub_db/webs_spec.rb
require 'spec_helper'
require 'webs_criteria'
require 'crm_formatter'

describe 'Webs' do
  let(:webs_obj) { ScrubDb::Webs.new }

  before { webs_obj.empty_criteria = false }
  before { webs_obj.filter = ScrubDb::Filter.new(WebsCriteria.all_scrub_web_criteria) }

  let(:array_of_urls) do
    %w[
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
  end

  describe '#scrub_urls' do
    let(:formatted_url_hashes) do
      [
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
          web_status: 'invalid',
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
          web_status: 'invalid',
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
          pos_paths: ['management, staff'],
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
    end

    it 'scrub_urls' do
      expect(webs_obj.scrub_urls(array_of_urls)).to eql(formatted_url_hashes)
    end
  end

  describe '#pre_scrub' do
    let(:hashes_in) do
      [
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
        {
          web_status: 'formatted',
          url: 'smith_acura.com/staff',
          url_f: 'http://www.smith_acura.com',
          url_path: '/staff',
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'formatted',
          url: 'abcrepair.ca',
          url_f: 'http://www.abcrepair.ca',
          url_path: nil,
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'formatted',
          url: 'hertzrentals.com/review',
          url_f: 'http://www.hertzrentals.com',
          url_path: '/review',
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'formatted',
          url: 'londonhyundai.uk/fleet',
          url_f: 'http://www.londonhyundai.uk',
          url_path: '/fleet',
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'formatted',
          url: 'http://www.townbuick.net/staff',
          url_f: 'http://www.townbuick.net',
          url_path: nil,
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'formatted',
          url: 'http://youtube.com/download',
          url_f: 'http://www.youtube.com',
          url_path: nil,
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'formatted',
          url: 'www.madridinfiniti.es/collision',
          url_f: 'http://www.madridinfiniti.es',
          url_path: '/collision',
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'invalid',
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
        {
          web_status: 'formatted',
          url: 'www.dallassubaru.com.sofake',
          url_f: 'http://www.dallassubaru.com',
          url_path: nil,
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'formatted',
          url: 'www.quickeats.net/contact_us',
          url_f: 'http://www.quickeats.net',
          url_path: '/contact_us',
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'formatted',
          url: 'www.school.edu/teachers',
          url_f: 'http://www.school.edu',
          url_path: '/teachers',
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'invalid',
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
        {
          web_status: 'formatted',
          url: 'www.www.toyotatown.net/staff/management',
          url_f: 'http://www.toyotatown.net',
          url_path: '/staff/management',
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'formatted',
          url: 'www.www.yellowpages.com/business',
          url_f: 'http://www.yellowpages.com',
          url_path: '/business',
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        }
      ]
    end

    let(:hashes_out) do
      [
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
          web_status: 'invalid',
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
          web_status: 'invalid',
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
          pos_paths: ['management, staff'],
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
    end

    it 'pre_scrub' do
      expect(webs_obj.pre_scrub(hashes_in)).to eql(hashes_out)
    end
  end

  describe '#merge_criteria_hashes' do
    let(:hashes_in) do
      [
        {
          web_status: 'invalid',
          url: 'austinchevrolet.not.real',
          url_f: nil,
          url_path: nil,
          web_neg: 'error: ext.invalid [not, real]'
        },
        {
          web_status: 'formatted',
          url: 'smith_acura.com/staff',
          url_f: 'http://www.smith_acura.com',
          url_path: '/staff',
          web_neg: nil
        },
        {
          web_status: 'formatted',
          url: 'abcrepair.ca',
          url_f: 'http://www.abcrepair.ca',
          url_path: nil,
          web_neg: nil
        },
        {
          web_status: 'formatted',
          url: 'hertzrentals.com/review',
          url_f: 'http://www.hertzrentals.com',
          url_path: '/review',
          web_neg: nil
        },
        {
          web_status: 'formatted',
          url: 'londonhyundai.uk/fleet',
          url_f: 'http://www.londonhyundai.uk',
          url_path: '/fleet',
          web_neg: nil
        },
        {
          web_status: 'formatted',
          url: 'http://www.townbuick.net/staff',
          url_f: 'http://www.townbuick.net',
          url_path: nil,
          web_neg: nil
        },
        {
          web_status: 'formatted',
          url: 'http://youtube.com/download',
          url_f: 'http://www.youtube.com',
          url_path: nil,
          web_neg: nil
        },
        {
          web_status: 'formatted',
          url: 'www.madridinfiniti.es/collision',
          url_f: 'http://www.madridinfiniti.es',
          url_path: '/collision',
          web_neg: nil
        },
        {
          web_status: 'invalid',
          url: 'www.mitsubishideals.sofake',
          url_f: nil, url_path: nil,
          web_neg: 'error: ext.invalid [sofake]'
        },
        {
          web_status: 'formatted',
          url: 'www.dallassubaru.com.sofake',
          url_f: 'http://www.dallassubaru.com',
          url_path: nil,
          web_neg: nil
        },
        {
          web_status: 'formatted',
          url: 'www.quickeats.net/contact_us',
          url_f: 'http://www.quickeats.net',
          url_path: '/contact_us',
          web_neg: nil
        },
        {
          web_status: 'formatted',
          url: 'www.school.edu/teachers',
          url_f: 'http://www.school.edu',
          url_path: '/teachers',
          web_neg: nil
        },
        {
          web_status: 'invalid',
          url: 'www.www.nissancars/inventory',
          url_f: nil,
          url_path: nil,
          web_neg: 'error: ext.none'
        },
        {
          web_status: 'formatted',
          url: 'www.www.toyotatown.net/staff/management',
          url_f: 'http://www.toyotatown.net',
          url_path: '/staff/management',
          web_neg: nil
        },
        {
          web_status: 'formatted',
          url: 'www.www.yellowpages.com/business',
          url_f: 'http://www.yellowpages.com',
          url_path: '/business',
          web_neg: nil
        }
      ]
    end

    let(:hashes_out) do
      [
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
        {
          web_status: 'formatted',
          url: 'smith_acura.com/staff',
          url_f: 'http://www.smith_acura.com',
          url_path: '/staff',
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'formatted',
          url: 'abcrepair.ca',
          url_f: 'http://www.abcrepair.ca',
          url_path: nil,
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'formatted',
          url: 'hertzrentals.com/review',
          url_f: 'http://www.hertzrentals.com',
          url_path: '/review',
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'formatted',
          url: 'londonhyundai.uk/fleet',
          url_f: 'http://www.londonhyundai.uk',
          url_path: '/fleet',
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'formatted',
          url: 'http://www.townbuick.net/staff',
          url_f: 'http://www.townbuick.net',
          url_path: nil,
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'formatted',
          url: 'http://youtube.com/download',
          url_f: 'http://www.youtube.com',
          url_path: nil,
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'formatted',
          url: 'www.madridinfiniti.es/collision',
          url_f: 'http://www.madridinfiniti.es',
          url_path: '/collision',
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'invalid',
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
        {
          web_status: 'formatted',
          url: 'www.dallassubaru.com.sofake',
          url_f: 'http://www.dallassubaru.com',
          url_path: nil,
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'formatted',
          url: 'www.quickeats.net/contact_us',
          url_f: 'http://www.quickeats.net',
          url_path: '/contact_us',
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'formatted',
          url: 'www.school.edu/teachers',
          url_f: 'http://www.school.edu',
          url_path: '/teachers',
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'invalid',
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
        {
          web_status: 'formatted',
          url: 'www.www.toyotatown.net/staff/management',
          url_f: 'http://www.toyotatown.net',
          url_path: '/staff/management',
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        },
        {
          web_status: 'formatted',
          url: 'www.www.yellowpages.com/business',
          url_f: 'http://www.yellowpages.com',
          url_path: '/business',
          web_neg: nil,
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        }
      ]
    end

    it 'merge_criteria_hashes' do
      expect(webs_obj.merge_criteria_hashes(hashes_in)).to eql(hashes_out)
    end
  end

  describe '#merge_criteria_hash' do
    let(:hash_in) do
      {
        web_status: 'invalid',
        url: 'austinchevrolet.not.real',
        url_f: nil,
        url_path: nil,
        web_neg: 'error: ext.invalid [not, real]'
      }
    end
    let(:hash_out) do
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
      }
    end

    it 'merge_criteria_hash' do
      expect(webs_obj.merge_criteria_hash(hash_in)).to eql(hash_out)
    end
  end

  describe '#extract_exts' do
    let(:hash_in) do
      {
        web_status: 'formatted',
        url: 'smith_acura.com/staff',
        url_f: 'http://www.smith_acura.com',
        url_path: '/staff',
        web_neg: nil,
        url_exts: [],
        neg_exts: [],
        pos_exts: [],
        neg_paths: [],
        pos_paths: [],
        neg_urls: [],
        pos_urls: []
      }
    end

    let(:url_exts) { ['com'] }

    it 'extract_exts' do
      expect(webs_obj.extract_exts(hash_in)).to eql(url_exts)
    end
  end

  describe '#scrub_url_hash' do
    let(:hash_in) do
      {
        web_status: 'formatted',
        url: 'smith_acura.com/staff',
        url_f: 'http://www.smith_acura.com',
        url_path: '/staff',
        web_neg: nil,
        url_exts: ['com'],
        neg_exts: [],
        pos_exts: [],
        neg_paths: [],
        pos_paths: [],
        neg_urls: [],
        pos_urls: []
      }
    end

    let(:hash_out) do
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
      }
    end

    it 'scrub_url_hash' do
      expect(webs_obj.scrub_url_hash(hash_in)).to eql(hash_out)
    end
  end
end
