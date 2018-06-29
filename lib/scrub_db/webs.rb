

module ScrubDb
  class Webs
    # attr_accessor :headers, :valid_rows, :encoded_rows, :row_id, :data_hash, :defective_rows, :error_rows

    def initialize(criteria={})
      @empty_criteria = criteria&.empty?
      @filter = ScrubDb::Filter.new(criteria) unless @empty_criteria
    end

    def scrub_urls(urls=[])
      formatted_url_hashes = CrmFormatter.format_urls(urls)
      formatted_url_hashes = merge_criteria_hashes(formatted_url_hashes)
      formatted_url_hashes = pre_scrub(formatted_url_hashes)
    end

    def pre_scrub(hashes)
      hashes = hashes.map do |hsh|
        if hsh[:url_f].present?
          hsh[:url_exts] = extract_exts(hsh)
          hsh = scrub_url_hash(hsh)
        end
        hsh
      end
    end

    def merge_criteria_hashes(hashes)
      hashes.map! do |url_hash|
        merge_criteria_hash(url_hash)
      end
    end

    def merge_criteria_hash(url_hash)
      url_hash.merge!(
        {
          url_exts: [],
          neg_exts: [],
          pos_exts: [],
          neg_paths: [],
          pos_paths: [],
          neg_urls: [],
          pos_urls: []
        }
      )
    end

    def extract_exts(url_hash)
      uri_parts = URI(url_hash[:url_f]).host&.split('.')
      url_exts = uri_parts[2..-1]
    end

    def scrub_url_hash(url_hash)
      url = url_hash[:url_f]
      path = url_hash[:url_path]
      href = url_hash[:href]
      url_exts = url_hash[:url_exts]

      url_hash = @filter.scrub_oa(url_hash, url_exts, 'neg_exts', 'equal')
      url_hash = @filter.scrub_oa(url_hash, url_exts, 'pos_exts', 'equal')
      url_hash = @filter.scrub_oa(url_hash, url, 'neg_urls', 'include')
      url_hash = @filter.scrub_oa(url_hash, url, 'pos_urls', 'include')
      url_hash = @filter.scrub_oa(url_hash, path, 'neg_paths', 'include')
      url_hash = @filter.scrub_oa(url_hash, path, 'pos_paths', 'include')
      url_hash
    end

  end

end
