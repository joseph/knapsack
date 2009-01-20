class Resource

  def self.fetch_and_convert(url, active_uri = nil)
    resource = fetch(url, active_uri)
    resource ? resource.convert : ''
  end

  def self.fetch(url, active_uri = nil)
    if url.match(/^data:/)
      url.instance_eval("def convert; self; end")
      return url
    end

    uri = URI.parse(url)
    unless uri.methods.include?('read')
      if active_uri
        uri = active_uri.merge(uri)
      else
        raise "Cannot form open-able URI from URL: #{url}"
      end
    end
    log "Fetching: #{url}"

    @@fetched_resources ||= {}
    key = uri.to_s
    response = @@fetched_resources[key]
    unless response
      begin
        response = uri.read(
          "User-Agent" => "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) " +
            "AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1C28 " +
            "Safari/419.3"
        )
      rescue OpenURI::HTTPError => e
        log e.inspect
        return nil
      end

      if response.content_encoding.any?
        if response.content_encoding.first.downcase == "gzip"
          rdr = Zlib::GzipReader.new(StringIO.new(response))
          response.replace(rdr.read)
        else
          raise "Unknown encoding: #{response.content_encoding.join(',')}"
        end

        if response.content_encoding.size > 1
          raise "Multiple encodings: #{response.content_encoding.join(',')}"
        end
      end
      @@fetched_resources[key] = response
    end

    recognise(response)
  end

  def self.recognise(response)
    raise "Unrecognised response" unless mime_type = response.content_type
    if mime_type == "text/html"
      Page.new(response)
    elsif mime_type == "text/css"
      Stylesheet.new(response)
    else
      new(response)
    end
  end

  def initialize(response)
    @data = response
    @mime_type = response.content_type
    @uri = response.base_uri
    @charset = response.charset
  end

  def convert
    @data = rewrite
    @data = encode
    @data = format_for_output
  end

  # Override this in subclasses to modify self (including other resources, etc).
  def rewrite
    (@data && !@data.empty?) ? @data : ''
  end

  def encode
    (@data && !@data.empty?) ? Base64.encode64(@data).gsub(/\n/,'') : ''
  end

  def format_for_output
    cs = @charset ? "charset=#{@charset};" : ''
    (@data && !@data.empty?) ? "data:#{@mime_type};#{cs}base64,#{@data}" : ''
  end

  def log(msg)
    puts msg
  end
  
  def self.log(msg)
    puts msg
  end

end
