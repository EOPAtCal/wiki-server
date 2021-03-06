require 'sinatra'
require './breadcrumbs.rb'
include BreadCrumbs
require './links.rb'
include Links
require "./helpers.rb"
include Helpers

$base_url = "http://eop.wikidot.com"
$host_url = "https://ce3-wiki.herokuapp.com"
set :layout => :flatui

get '/' do
  @paths, @current_navitem = [], "Home"
  @wiki_links = [$host_url + "/wiki:eop-wiki",
                 $host_url + "/wiki:undocumented-student-program-wiki",
                 $host_url + "/wiki:transfer-student-services-center"]
  @external_links = []
  erb :index
end

get '*' do |link|
  link = link << ".html"
  begin
    html_content = File.read(File.join("public", link))
  rescue Exception => e
    puts "unable to read #{link}"
    return 404, "Content not found"
  else
    original_link = link
    link = format_link(link)
    @paths = generate_breadcrumbs(link)
    @current_navitem = get_nav_item(@paths.last)
    @paths = @paths.first(@paths.size-1)
    @paths = @paths.map { |p| hosturl_sub(p, $base_url, $host_url) }
    path = original_link.split(".com/")[1]
    links = get_links(File.join("public", path), $host_url)
    @wiki_links, @external_links = links[0], links[1]
    erb html_content
  end
end

# helper
def format_link(link)
  link.prepend($base_url)
  link.chomp(".html")
end


helpers do
  def partition_link(link)
    link.rpartition(":").last == "" ?  link : link.rpartition(":").last
  end

  def remove_leading_slash(link)
    link.gsub!(/^\/*/, "")
  end

  def remove_trailing_slash(link)
    link.gsub!(/\/*$/, "")
  end

  def process_sidebar_link(link)
    remove_trailing_slash(remove_leading_slash(partition_link(link)))
  end
end