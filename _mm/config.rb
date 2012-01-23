activate :blog
set :blog_permalink, ":year/:month/:title.html"
# set :blog_summary_separator, /READMORE/
# set :blog_summary_length, 500
set :markdown, :layout_engine => :erb

set :blog_taglink, "categories/:tag.html"

page "/feed.xml", :layout => false
#page "/2*", :layout => "layout-article"

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css
  
  # Minify Javascript on build
  # activate :minify_javascript
  
  # Enable cache buster
  # activate :cache_buster
  activate :smusher
end

require 'rack/codehighlighter'
use Rack::Codehighlighter, 
  :pygments_api,
  :element => "pre>code",
  :pattern => /\A:::([-_+\w]+)\s*\n/,
  :markdown => true


module Middleman::Features::Reference
  class << self
    def registered(app)
      app.extend ClassMethods
    end
    alias :included :registered
  end

  module ClassMethods
    def say_hello
      puts "Hello"
    end
  end
end
activate :reference

module Middleman::Features::MyHelpers
  class << self
    def registered(app)
      app.helpers HelperMethods
    end
    alias :included :registered
  end

  module HelperMethods
    def custom_side_image
      %Q|style="background-image: url(/img/#{side_image})"| if side_image?
    end

    def current_article
      data.blog.articles.find {|a| a.title == current_article_title }
    end

    def side_image?
      !side_image.blank?
    end

    def side_image
      current_article.sideimage if is_blog_article?
    end
  end

end
activate :my_helpers



