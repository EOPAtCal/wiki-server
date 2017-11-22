require "./helpers.rb"
require 'nokogiri'
include Helpers

module Links
  def get_links(path, base_url)
    page = Nokogiri::HTML(open(path))
    links = page.css('a')
    hrefs = links.map { |link| link["href"] }
    wiki_links = hrefs.select { |link| check_link?(link, base_url) }

    external_links = []
    items = [base_url, 'system:page-tags/tag/', 'javascript']
    items.each do |item|
      external_links = hrefs.select { |link| !check_link?(link, item) }
    end
    return [wiki_links.map { |l| clean_link(l) }, external_links.map { |link| clean_link(link) }]
  end

  def check_link?(link, base_url)
    link.include? base_url
  end

  def clean_link(link)
    link = link.gsub!(/^\/*/, "")
    link.gsub!(/\/*$/, "")
  end
end
