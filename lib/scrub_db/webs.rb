

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

      formatted_url_hashes.map! do |url_hash|
        if url_hash[:ScrubWeb_status] != 'invalid' && url_hash[:url_f].present?
          url_hash[:url_exts] = extract_exts(url_hash)
          url_hash = scrub_url_hash(url_hash)
        end
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

    # def remove_invalid_links(link)
    #   link_hsh = { link: link, valid_link: nil, flags: nil }
    #   return link_hsh unless link.present?
    #   @neg_paths += get_symbs
    #   flags = @neg_paths.select { |red| link&.include?(red) }
    #   flags << "below #{2}" if link.length < 2
    #   flags << "over #{100}" if link.length > 100
    #   flags = flags.flatten.compact
    #   valid_link = flags.any? ? nil : link
    #   link_hsh[:valid_link] = valid_link
    #   link_hsh[:flags] = flags.join(', ')
    #   binding.pry
    #   link_hsh
    # end

    # def remove_invalid_hrefs(href)
    #   href_hsh = { href: href, valid_href: nil, flags: nil }
    #   return href_hsh unless href.present?
    #   @neg_hrefs += get_symbs
    #   href = href.split('|').join(' ')
    #   href = href.split('/').join(' ')
    #   href&.gsub!('(', ' ')
    #   href&.gsub!(')', ' ')
    #   href&.gsub!('[', ' ')
    #   href&.gsub!(']', ' ')
    #   href&.gsub!(',', ' ')
    #   href&.gsub!("'", ' ')
    #
    #   flags = []
    #   flags << "over #{100}" if href.length > 100
    #   invalid_text = Regexp.new(/[0-9]/)
    #   flags << invalid_text&.match(href)
    #   href = href&.downcase
    #   href = href&.strip
    #
    #   flags << @neg_hrefs.select { |red| href&.include?(red) }
    #   flags = flags.flatten.compact.uniq
    #   href_hsh[:valid_href] = href unless flags.any?
    #   href_hsh[:flags] = flags.join(', ')
    #   href_hsh
    # end

  end

end
