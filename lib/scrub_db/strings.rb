

module ScrubDb
  class Strings
    attr_accessor :filter, :empty_criteria

    def initialize(criteria={})
      @empty_criteria = criteria&.empty?
      @filter = ScrubDb::Filter.new(criteria) unless @empty_criteria
    end

    def scrub_proper_strings(props=[])
      prop_hashes = CrmFormatter.format_propers(props)
      prop_hashes = merge_criteria(prop_hashes)
      prop_hashes.map! { |prop_hsh| scrub_hash(prop_hsh) }
    end

    def scrub_strings(strings=[])
      str_hashes = strings_to_hashes(strings)
      str_hashes = merge_criteria(str_hashes)
      str_hashes.map! { |str_hsh| scrub_hash(str_hsh) }
    end

    def strings_to_hashes(strings)
      str_hashes = strings.map { |str| { string: str } }
    end

    def merge_criteria(hashes)
      hashes.map do |hsh|
        hsh.merge({ pos_criteria: [], neg_criteria: [] })
      end
    end

    def scrub_hash(hsh)
      str = hsh[:string]
      prop = hsh[:proper_f]

      if str.present?
        hsh = @filter.scrub_oa(hsh, str, 'neg_criteria', 'include')
        hsh = @filter.scrub_oa(hsh, str, 'pos_criteria', 'include')
      end

      if prop.present?
        hsh = @filter.scrub_oa(hsh, prop, 'neg_criteria', 'include')
        hsh = @filter.scrub_oa(hsh, prop, 'pos_criteria', 'include')
      end
      hsh
    end

  end

end
