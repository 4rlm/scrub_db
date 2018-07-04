
module ScrubDb
  class Strings
    attr_accessor :filter, :empty_criteria

    def initialize(criteria={})
      @empty_criteria = criteria&.empty?
      @filter = ScrubDb::Filter.new(criteria) unless @empty_criteria
      @crmf = CrmFormatter
    end

    def scrub_proper_strings(props=[])
      prop_hashes = props.map! { |str| scrub_proper_string(str) }
    end

    def scrub_strings(strs=[])
      str_hashes = strs.map! { |str| scrub_string(str) }
    end


    def scrub_proper_string(string)
      hsh = @crmf.format_proper(string)
      hsh = merge_criteria(hsh)
      hsh = scrub_hash(hsh)
    end

    def scrub_string(string)
      hsh = string_to_hash(string)
      hsh = merge_criteria(hsh)
      hsh = scrub_hash(hsh)
    end


    def string_to_hash(string)
      hsh = { string: string, pos_criteria: [], neg_criteria: [] }
    end

    def merge_criteria(hsh)
      hsh = hsh.merge({ pos_criteria: [], neg_criteria: [] })
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
