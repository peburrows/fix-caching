require 'hpricot'

module CachedSitemapTags
  include Radiant::Taggable

  tag 'cached' do |tag|
    tag.expand
  end
  
  tag 'cached:body' do |tag|
    cache = ResponseCache.instance
    url = tag.attr['url'].gsub(/(^\/)|(\/$)/, '') # get rid of slashes at the end or beginning of the url
    if cache.response_cached?(tag.attr['url'].strip)
      file_path = cache.directory + tag.attr['url'].strip
      data = File.open("#{file_path}.data", "rb") {|f| f.read}
      if tag.attr['part']
        doc = Hpricot(data)
        doc.search(tag.attr['part'].strip).first.to_s
      else
        data
      end
    else
      'that url has not been cached'
    end
  end
  
  tag 'if_cached' do |tag|
    cache = ResponseCache.instance
    tag.expand if cache.response_cached?(tag.attr['url'].strip)
  end
  
  tag 'unless_cached' do |tag|
    cache = ResponseCache.instance
    tag.expand unless cache.response_cached?(tag.attr['url'].strip)
  end

end