

module ScrubDb
  class Web
    # attr_accessor :headers, :valid_rows, :encoded_rows, :row_id, :data_hash, :defective_rows, :error_rows

    def initialize(criteria={})
      @empty_criteria = criteria&.empty?
      @filter = ScrubDb::Filter.new(criteria) unless @empty_criteria
    end

    def scrub_ext(urls=[])
      binding.pry
      return { url_hash: url_hash, url: url } if @empty_criteria
      # run_scrub(url_hash, url, matched_exts)
    end

    def run_scrub(url_hash, url, matched_exts)
      url_hash = @tools.scrub_oa(url_hash, matched_exts, 'pos_exts', 'equal')
      url_hash = @tools.scrub_oa(url_hash, matched_exts, 'neg_exts', 'equal')
      url_hash = @tools.scrub_oa(url_hash, url, 'pos_urls', 'include')
      url_hash = @tools.scrub_oa(url_hash, url, 'neg_urls', 'include')
      { url_hash: url_hash, url: url }
    end

    def remove_invalid_links(link)
      link_hsh = { link: link, valid_link: nil, flags: nil }
      return link_hsh unless link.present?
      @neg_links += get_symbs
      flags = @neg_links.select { |red| link&.include?(red) }
      flags << "below #{2}" if link.length < 2
      flags << "over #{100}" if link.length > 100
      flags = flags.flatten.compact
      valid_link = flags.any? ? nil : link
      link_hsh[:valid_link] = valid_link
      link_hsh[:flags] = flags.join(', ')
      link_hsh
    end

    def remove_invalid_hrefs(href)
      href_hsh = { href: href, valid_href: nil, flags: nil }
      return href_hsh unless href.present?
      @neg_hrefs += get_symbs
      href = href.split('|').join(' ')
      href = href.split('/').join(' ')
      href&.gsub!('(', ' ')
      href&.gsub!(')', ' ')
      href&.gsub!('[', ' ')
      href&.gsub!(']', ' ')
      href&.gsub!(',', ' ')
      href&.gsub!("'", ' ')

      flags = []
      flags << "over #{100}" if href.length > 100
      invalid_text = Regexp.new(/[0-9]/)
      flags << invalid_text&.match(href)
      href = href&.downcase
      href = href&.strip

      flags << @neg_hrefs.select { |red| href&.include?(red) }
      flags = flags.flatten.compact.uniq
      href_hsh[:valid_href] = href unless flags.any?
      href_hsh[:flags] = flags.join(', ')
      href_hsh
    end

  end

end
