# frozen_string_literal: true

# rspec spec/scrub_db/filter_spec.rb
require 'spec_helper'

describe 'Filter' do
  let(:filter_obj) { ScrubDb::Filter.new }

  let(:pos_criteria) do
    ["acura", "alfa romeo", "aston martin", "audi", "bmw", "bentley", "bugatti", "buick", "cdjr", "cadillac", "chevrolet", "chrysler", "dodge", "ferrari", "fiat", "ford", "gmc", "group", "group", "honda", "hummer", "hyundai", "infiniti", "isuzu", "jaguar", "jeep", "kia", "lamborghini", "lexus", "lincoln", "lotus", "mini", "maserati", "mazda", "mclaren", "mercedes-benz", "mitsubishi", "nissan", "porsche", "ram", "rolls-royce", "saab", "scion", "smart", "subaru", "suzuki", "toyota", "volkswagen", "volvo"]
  end

  let(:neg_criteria) do
    %w[approv avis budget collis eat enterprise facebook financ food google gourmet hertz hotel hyatt insur invest loan lube mobility motel motorola parts quick rent repair restaur rv ryder service softwar travel twitter webhost yellowpages yelp youtube]
  end

  before { filter_obj.args = {pos_criteria: pos_criteria, neg_criteria: neg_criteria} }
  before { filter_obj.empty_criteria = false }

  describe '#scrub_oa' do
    let(:hash) do
      {
      :string=>"quick auto-approval gmc and bmw-world of AUSTIN tx, INC",
      :pos_criteria=>[],
      :neg_criteria=>[]
      }
    end

    let(:target) { "quick auto-approval gmc and bmw-world of AUSTIN tx, INC" }
    let(:oa_name) { "neg_criteria" }
    let(:include_or_equal) { 'include' }
    let(:hsh_out) do
      {
      :string=>"quick auto-approval gmc and bmw-world of AUSTIN tx, INC",
      :pos_criteria=>[],
      :neg_criteria=>["approv, quick"]
      }
    end

    it 'scrub_oa' do
      expect(filter_obj.scrub_oa(hash, target, oa_name, include_or_equal)).to eql(hsh_out)
    end
  end


  describe '#match_to_hash' do
    let(:hsh) do
      {
      :string=>"quick auto-approval gmc and bmw-world of AUSTIN tx, INC",
      :pos_criteria=>[],
      :neg_criteria=>[]
      }
    end

    let(:match) { "approv, quick" }
    let(:oa_name) { "neg_criteria" }

    let(:hsh_out) do
      {
      :string=>"quick auto-approval gmc and bmw-world of AUSTIN tx, INC",
      :pos_criteria=>[],
      :neg_criteria=>["approv, quick"]
      }
    end

    it 'match_to_hash' do
      expect(filter_obj.match_to_hash(hsh, match, oa_name)).to eql(hsh_out)
    end
  end


  describe '#stringify_matches' do
    let(:matches) { ["quick", "approv"] }
    let(:string_match) { "approv, quick" }

    it 'stringify_matches' do
      expect(filter_obj.stringify_matches(matches)).to eql(string_match)
    end
  end


  describe '#fetch_criteria' do
    let(:oa_name) { 'neg_criteria' }

    let(:criteria) do
      %w[approv avis budget collis eat enterprise facebook financ food google gourmet hertz hotel hyatt insur invest loan lube mobility motel motorola parts quick rent repair restaur rv ryder service softwar travel twitter webhost yellowpages yelp youtube]
    end

    it 'fetch_criteria' do
      expect(filter_obj.fetch_criteria(oa_name)).to eql(criteria)
    end
  end


  describe '#match_criteria' do
    let(:tars) { %w[quick, auto, approval, gmc, and, bmw, world, of, austin, tx, inc] }
    let(:include_or_equal) { 'include' }
    let(:criteria) do
      %w[approv avis budget collis eat enterprise facebook financ food google gourmet hertz hotel hyatt insur invest loan lube mobility motel motorola parts quick rent repair restaur rv ryder service softwar travel twitter webhost yellowpages yelp youtube]
    end

    let(:scrub_matches) { ["quick", "approv"] }

    it 'match_criteria' do
      expect(filter_obj.match_criteria(tars, include_or_equal, criteria)).to eql(scrub_matches)
    end
  end


  describe '#prep_target' do
    let(:target_in) { "quick auto-approval gmc and bmw-world of AUSTIN tx, INC" }
    let(:target_out) { "quick auto approval gmc and bmw world of austin tx inc" }

    it 'prep_target' do
      expect(filter_obj.prep_target(target_in)).to eql(target_out)
    end
  end


  describe '#target_to_tars' do
    let(:target) { "quick auto approval gmc and bmw world of austin tx inc" }
    let(:tars) { %w[quick auto approval gmc and bmw world of austin tx inc] }

    it 'target_to_tars' do
      expect(filter_obj.target_to_tars(target)).to eql(tars)
    end
  end


end
