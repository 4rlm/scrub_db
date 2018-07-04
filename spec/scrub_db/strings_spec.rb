
# rspec spec/scrub_db/strings_spec.rb
require 'spec_helper'

describe 'Strings' do
  let(:pos_criteria) do
    ['acura', 'alfa romeo', 'aston martin', 'audi', 'bmw', 'bentley', 'bugatti', 'buick', 'cdjr', 'cadillac', 'chevrolet', 'chrysler', 'dodge', 'ferrari', 'fiat', 'ford', 'gmc', 'group', 'group', 'honda', 'hummer', 'hyundai', 'infiniti', 'isuzu', 'jaguar', 'jeep', 'kia', 'lamborghini', 'lexus', 'lincoln', 'lotus', 'mini', 'maserati', 'mazda', 'mclaren', 'mercedes-benz', 'mitsubishi', 'nissan', 'porsche', 'ram', 'rolls-royce', 'saab', 'scion', 'smart', 'subaru', 'suzuki', 'toyota', 'volkswagen', 'volvo']
  end

  let(:array_of_strings) do
    [
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
  end

  let(:neg_criteria) do
    %w[approv avis budget collis eat enterprise facebook financ food google gourmet hertz hotel hyatt insur invest loan lube mobility motel motorola parts quick rent repair restaur rv ryder service softwar travel twitter webhost yellowpages yelp youtube]
  end

  let(:criteria) do
    { pos_criteria: pos_criteria, neg_criteria: neg_criteria }
  end

  let(:strings_obj) { ScrubDb::Strings.new }
  # let(:filter) { ScrubDb::Filter.new(criteria) }
  before { strings_obj.empty_criteria = false }
  before { strings_obj.filter = ScrubDb::Filter.new(criteria) }


  describe '#scrub_proper_string' do
    let(:string) { "quick auto-approval gmc and bmw-world of AUSTIN tx, INC" }
    let(:hash) do
      {
        :proper_status=>"formatted",
        :proper=>"quick auto-approval gmc and bmw-world of AUSTIN tx, INC",
        :proper_f=>"Quick Auto-Approval GMC and BMW-World of Austin TX Inc",
        :pos_criteria=>["bmw, gmc"],
        :neg_criteria=>["approv, quick"]
      }
    end

    it 'scrub_proper_string' do
      expect(strings_obj.scrub_proper_string(string)).to eql(hash)
    end
  end

  describe '#scrub_string' do
    let(:string) { "quick auto-approval gmc and bmw-world of AUSTIN tx, INC" }
    let(:hash) do
      {
        :string=>"quick auto-approval gmc and bmw-world of AUSTIN tx, INC",
        :pos_criteria=>["bmw, gmc"],
        :neg_criteria=>["approv, quick"]
      }
    end

    it 'scrub_string' do
      expect(strings_obj.scrub_string(string)).to eql(hash)
    end
  end


  describe '#scrub_proper_strings' do
    let(:prop_hashes) do
      [
        {:proper_status=>"formatted",
        :proper=>"quick auto-approval gmc and bmw-world of AUSTIN tx, INC",
        :proper_f=>"Quick Auto-Approval GMC and BMW-World of Austin TX Inc",
        :pos_criteria=>["bmw, gmc"],
        :neg_criteria=>["approv, quick"]},
       {:proper_status=>"formatted",
        :proper=>"quick auto-approval, inc",
        :proper_f=>"Quick Auto-Approval, Inc",
        :pos_criteria=>[],
        :neg_criteria=>["approv, quick"]},
       {:proper_status=>"formatted", :proper=>"DOWNTOWN CAR REPAIR, INC", :proper_f=>"Downtown Car Repair, Inc", :pos_criteria=>[], :neg_criteria=>["repair"]},
       {:proper_status=>"formatted", :proper=>"TEXAS TRAVEL, CO", :proper_f=>"Texas Travel, CO", :pos_criteria=>[], :neg_criteria=>["travel"]},
       {:proper_status=>"formatted",
        :proper=>"123 Car-world Kia OF CHICAGO IL",
        :proper_f=>"123 Car-World Kia of Chicago IL",
        :pos_criteria=>["kia"],
        :neg_criteria=>[]},
       {:proper_status=>"formatted",
        :proper=>"Main Street Ford in DALLAS tX",
        :proper_f=>"Main Street Ford in Dallas TX",
        :pos_criteria=>["ford"],
        :neg_criteria=>[]},
       {:proper_status=>"formatted", :proper=>"broad st fiat of houston", :proper_f=>"Broad St Fiat of Houston", :pos_criteria=>["fiat"], :neg_criteria=>[]},
       {:proper_status=>"formatted", :proper=>"hot-deal auto insurance", :proper_f=>"Hot-Deal Auto Insurance", :pos_criteria=>[], :neg_criteria=>["insur"]},
       {:proper_status=>"formatted",
        :proper=>"BUDGET - AUTOMOTORES ZONA & FRANCA, INC",
        :proper_f=>"Budget - Automotores Zona & Franca, Inc",
        :pos_criteria=>[],
        :neg_criteria=>["budget"]},
       {:proper_status=>"formatted", :proper=>"Young Gmc Trucks", :proper_f=>"Young GMC Trucks", :pos_criteria=>["gmc"], :neg_criteria=>[]},
       {:proper_status=>"formatted", :proper=>"youmans Chevrolet", :proper_f=>"Youmans Chevrolet", :pos_criteria=>["chevrolet"], :neg_criteria=>[]},
       {:proper_status=>"formatted", :proper=>"yazell chevy", :proper_f=>"Yazell Chevy", :pos_criteria=>[], :neg_criteria=>[]},
       {:proper_status=>"formatted", :proper=>"quick cAr LUBE", :proper_f=>"Quick Car Lube", :pos_criteria=>[], :neg_criteria=>["lube, quick"]},
       {:proper_status=>"formatted", :proper=>"yAtEs AuTo maLL", :proper_f=>"Yates Auto Mall", :pos_criteria=>[], :neg_criteria=>[]},
       {:proper_status=>"formatted", :proper=>"YADKIN VALLEY COLLISION CO", :proper_f=>"Yadkin Valley Collision CO", :pos_criteria=>[], :neg_criteria=>["collis"]},
       {:proper_status=>"formatted", :proper=>"XIT FORD INC", :proper_f=>"Xit Ford Inc", :pos_criteria=>["ford"], :neg_criteria=>[]}
      ]
    end

    it 'scrub_proper_strings' do
      expect(strings_obj.scrub_proper_strings(array_of_strings)).to eql(prop_hashes)
    end
  end

  describe '#scrub_strings' do
    let(:str_hashes) do
      [
        {
          string: 'quick auto-approval gmc and bmw-world of AUSTIN tx, INC',
          pos_criteria: ['bmw, gmc'],
          neg_criteria: ['approv, quick']
        },
        {
          string: 'quick auto-approval, inc',
          pos_criteria: [],
          neg_criteria: ['approv, quick']
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
    end

    it 'scrub_strings' do
      expect(strings_obj.scrub_strings(array_of_strings)).to eql(str_hashes)
    end
  end

  describe '#string_to_hash' do
    let(:string) { 'quick auto-approval gmc and bmw-world of AUSTIN tx, INC' }

    let(:hash) do
      {:string=>"quick auto-approval gmc and bmw-world of AUSTIN tx, INC", :pos_criteria=>[], :neg_criteria=>[]}
    end

    it 'string_to_hash' do
      expect(strings_obj.string_to_hash(string)).to eql(hash)
    end
  end

  describe '#merge_criteria' do
    let(:hash_in) do
      {:proper_status=>"formatted", :proper=>"quick auto-approval gmc and bmw-world of AUSTIN tx, INC", :proper_f=>"Quick Auto-Approval GMC and BMW-World of Austin TX Inc"}
    end
    let(:hash_out) do
      {:proper_status=>"formatted", :proper=>"quick auto-approval gmc and bmw-world of AUSTIN tx, INC", :proper_f=>"Quick Auto-Approval GMC and BMW-World of Austin TX Inc", :pos_criteria=>[], :neg_criteria=>[]}
    end

    it 'merge_criteria' do
      expect(strings_obj.merge_criteria(hash_in)).to eql(hash_out)
    end
  end

  describe '#scrub_hash' do
    let(:hsh_in) do
      {
        proper_status: 'formatted',
        proper: 'quick auto approval, inc',
        proper_f: 'Quick Auto Approval, Inc',
        pos_criteria: [],
        neg_criteria: []
      }
    end
    let(:hsh_out) do
      {
        proper_status: 'formatted',
        proper: 'quick auto approval, inc',
        proper_f: 'Quick Auto Approval, Inc',
        pos_criteria: [],
        neg_criteria: ['approv, quick']
      }
    end

    it 'scrub_hash' do
      expect(strings_obj.scrub_hash(hsh_in)).to eql(hsh_out)
    end
  end
end
