require "./helpers.rb"
include Helpers

module BreadCrumbs
  def generate_breadcrumbs(path)
    fpath = "./logs/path.bfs"

    if path == "http://eop.wikidot.com/wiki:eop-websites-social-media"
      path << "//"
    end

    content = read_file(fpath)
    paths = Hash.new
    content.each_line do |line|
      result = line.split(/: +/)
      key = result[0].strip!
      values = result[1].split(/> +/).drop(1)
      values.each do |val|
        val.strip!
      end

      if values.empty?
        paths[key] = ["/"]
      else
        paths[key] = values
      end
      paths[key] << key
      paths[key].reject { |p| p.empty? }
    end
    if paths.has_key? path
      unless paths[path].include? "/"
        paths[path].unshift("/")
      end
      return paths[path]
    else
      puts "could not find entry with key #{path}"
      return []
    end
  end
end