# frozen_string_literal: false

module ScrubDb
  class Filter
    attr_accessor :args, :empty_criteria

    def initialize(args={})
      @args = args
      @empty_criteria = args.empty?
    end

    def scrub_oa(hash, target, oa_name, include_or_equal)
      return hash unless oa_name.present? && !@empty_criteria && target.present?
      criteria = fetch_criteria(oa_name)

      return hash unless criteria.any?
      target = prep_target(target)
      tars = target_to_tars(target)
      scrub_matches = match_criteria(tars, include_or_equal, criteria)
      string_match = stringify_matches(scrub_matches)
      hash = match_to_hash(hash, string_match, oa_name)
    end

    def match_to_hash(hsh, match, oa_name)
      return hsh unless match.present?
      hsh[oa_name.to_sym] << match
      hsh
    end

    def stringify_matches(matches=[])
      string_match = matches&.uniq&.sort&.join(', ') if matches.any?
    end

    def fetch_criteria(oa_name)
      criteria = @args.fetch(oa_name.to_sym, [])
      criteria = criteria&.map(&:downcase)
    end


    def match_criteria(tars, include_or_equal, criteria)
      scrub_matches = tars.map do |tar|
        if include_or_equal == 'include'
          criteria.map { |crit| crit if tar.include?(crit) }
        elsif include_or_equal == 'equal'
          criteria.map { |crit| crit if tar == crit }
        end
      end
      scrub_matches = scrub_matches.flatten.compact
    end

    def prep_target(target)
      target = target.join if target.is_a?(Array)
      target = target.downcase
      target = target.gsub(',', ' ')
      target = target.gsub('-', ' ')
      target = target.squeeze(' ')
    end

    def target_to_tars(target)
      tars = target.is_a?(::String) ? target.split(' ') : target
    end


    ######################################


    # def grab_global_hash
    #   keys = %i[row_id act_name street city state zip full_addr phone url street_f city_f state_f zip_f full_addr_f phone_f url_f url_path ScrubWeb_neg address_status phone_status ScrubWeb_status utf_status]
    #   @global_hash = Hash[keys.map { |a| [a, nil] }]
    # end

    # def update_global_hash(local_keys)
    #   gkeys = @global_hash.keys
    #   lkeys = local_keys.uniq.sort
    #   # lkeys = lkeys.map(&:to_sym)
    #   # gkeys = gkeys.map(&:to_sym)
    #   add_to_global = lkeys - gkeys
    #   same_keys = lkeys && gkeys
    #   add_to_global += same_keys - gkeys
    #   add_to_global&.uniq!
    #
    #   if add_to_global.any?
    #     add_to_global += gkeys
    #     row = add_to_global.map { |_| nil }
    #     @global_hash = row_to_hsh(global_keys, row)
    #   end
    # end

    # def row_to_hsh(headers, row)
    #   headers = headers.map(&:to_sym)
    #   hash = Hash[headers.zip(row)]
    # end


    # def letter_case_check(str)
    #   return unless str.present?
    #   flashes = str&.gsub(/[^ A-Za-z]/, '')&.strip&.split(' ')
    #   flash = flashes&.reject { |e| e.length < 3 }&.join(' ')
    #
    #   return str unless flash.present?
    #   has_caps = flash.scan(/[A-Z]/).any?
    #   has_lows = flash.scan(/[a-z]/).any?
    #
    #   return str unless !has_caps || !has_lows
    #   str = str.split(' ')&.each { |el| el.capitalize! if el.gsub(/[^ A-Za-z]/, '')&.strip&.length > 2 }&.join(' ')
    # end

    ### Save for later. ###

    ### These two methods can set instance vars from args.
    # def set(name, value)
    #   var_name = "@#{name}"  # the '@' is required
    #   self.instance_variable_set(var_name, value)
    # end

    # def set_args(args, inst_vars)
    #   return unless args.any?
    #   args.symbolize_keys!
    #   keys_to_slice = (args.keys.uniq) & inst_vars
    #   args.slice!(*keys_to_slice)
    #   args
    # end

    # def compare_diff(hsh)
    #   res = []
    #   hsh.to_a.reduce do |el, nxt|
    #     res << nxt.first if el.last != nxt.last
    #     el = nxt
    #   end
    #   res.compact!
    # end

  end
end
