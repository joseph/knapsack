class Page < Resource

  def rewrite
    doc = Hpricot(@data)

    # Replace <style>@import "xxx";</style> lines with inline css.
    if true
      doc.search('style') do |style|
        spinner do
          style.inner_html = style.inner_html.gsub(/@import ["'](.*?)["']/) do
            ss = Resource.fetch($1, @uri)
            ss.rewrite
          end
        end
      end
    end
        
    # Replace stylesheet link hrefs with data uris
    if true
      doc.search('link[@rel$="tylesheet"]') do |sslink|
        spinner do
          d = Resource.fetch_and_convert(sslink.attributes['href'], @uri)
          sslink.set_attribute('href', d)
        end
      end
    end

    # Handle inline style definitions.
    if true
      doc.search('*[@style]') do |styled_elem|
        if styled_elem.attributes['style'].match(/url\(.*?\)/)
          spinner do
            d = styled_elem.attributes['style'].gsub(/url\((.*?)\)/) do
              "url(" + Resource.fetch_and_convert($1, @uri) + ")"
            end
            styled_elem.set_attribute('style', d)
          end
        end
      end
    end

    # Replace <img> src attributes with data uris.
    if true
      doc.search("img[@src]") do |img|
        spinner do
          d = Resource.fetch_and_convert(img.attributes['src'], @uri)
          img.set_attribute('src', d)
        end
      end
    end

    # Likewise for <script> elements.
    if true
      doc.search("script[@src]") do |script|
        spinner do
          d = Resource.fetch_and_convert(script.attributes['src'], @uri)
          script.set_attribute('src', d)
        end
      end
    end

    knotter

    doc.to_html
  end

  private
    def spinner
      @threads ||= []
      @threads << Thread.new { yield }
    end

    def knotter
      if @threads && @threads.any?
        @threads.each {|thd| thd.join} 
      end
    end

end
