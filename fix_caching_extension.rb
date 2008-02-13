# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class FixCachingExtension < Radiant::Extension
  version "1.0"
  description "An attempt to fix the Radiant page caching and allow you to actually turn it off"
  url "http://philburrows.com"
  
  def activate
    Page.send :include, CachedSitemapTags
    # an attempt to fix caching in Radiant and honor the configuration set up in the different environment files
    SiteController.class_eval{
      # here we override the show_page
      def show_page
        response.headers.delete('Cache-Control')
        url = params[:url].to_s
        # make sure @cache.perform_caching is set to true
        if (request.get? || request.head?) and live? and @cache.perform_caching and (@cache.response_cached?(url))
          logger.error("\n-------\n rendering cached page :: #{url}\n--------\n")
          @cache.update_response(url, response, request)
          @performed_render = true
        else
          logger.error("\n-------\n rendering UNcached page :: #{url}\n--------\n")
          show_uncached_page(url)
        end
      end
    }
  end
  
  def deactivate
  end
  
end