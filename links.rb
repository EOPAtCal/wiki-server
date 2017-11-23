require "./helpers.rb"
require 'nokogiri'
include Helpers

module Links
  def get_links(path, base_url)
    page = Nokogiri::HTML(open(path))
    links = page.css('a')
    hrefs = links.map { |link| link["href"] }
    wiki_links = hrefs.select { |link| check_link?(link, base_url) }

    external_links = hrefs - wiki_links
    items = ['system:page-tags/tag/', 'javascript']
    items.each do |item|
      external_links = external_links.reject { |l| check_link(l, item) }
    end
    wiki_links = wiki_links.map { |l| clean_link(l) },
      external_links = external_links.map { |link| clean_link(link) }
    return [wiki_links.uniq, external_links.uniq]
  end

  def check_link?(link, item)
    link.include? item
  end

  def clean_link(link)
    link = link.gsub!(/^\/*/, "")
    link.gsub!(/\/*$/, "")
  end
end
