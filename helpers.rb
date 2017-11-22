module Helpers
  def get_nav_item(link)
    link.rpartition(":").last
  end

  def hosturl_sub(url, from, to)
    url.gsub(from, to)
  end

  def read_file(fpath)
    content = ""
    begin
      content = File.read(fpath)
    rescue Exception => e
      puts e.to_s
    end
    return content
  end
end
