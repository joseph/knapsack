class Stylesheet < Resource

  def rewrite
    # Replace urls with data uris
    if true
      @data.gsub!(/url\((.*?)\)/) do 
        "url(" + Resource.fetch_and_convert($1, @uri) + ")"
      end
    end
  end

end
