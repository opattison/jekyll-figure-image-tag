# Title: Figure/image tag plugin for Jekyll
# Author: Oliver Pattison | http://oliverpattison.org
# Description: Create figure/img HTML blocks with optional classes and captions. This is a YAML-dependent Liquid tag plugin for Jekyll for those who fear link rot.
# 
# Download/source/issues: https://github.com/opattison/jekyll-figure-image-tag
# Documentation: https://github.com/opattison/jekyll-figure-image-tag/blob/master/README.md
# 
# Note: designed specifically for implementations with YAML front matter-based images, captions and alt text.
# Create simple YAML sequences (arrays) in the post's front matter like this:
# 
#   image:
#     - path/to/image
#     - path/to/another-image
#   image_alt:
#     - 'alt text'
#     - 'more alt text'
#   image_caption:
#     - 'A photo from my trip to [the solar farm](http://example.com).'
#     - 'Another photo from my trip.' 
# 
# Make sure to have an image domain specified in the _config.yml file:
# 
#   image_url: http://images.example.com
# 
# Syntax: 
# {% figure_img [class name(s)] integer [caption] %}
# 
# Sample (typical use): 
# {% figure_img left 0 caption %}
#
# Output:
# <figure class="left">
#   <img src="http://images.example.com/solar-farm.jpg" alt="Landscape view of solar farm">
#   <figcaption>
#     <p>A photo from my trip to <a href="http://example.com">the solar farm</a>.</p>
#   </figcaption>
# </figure>
# 

module Jekyll
  class FigureImageTag < Liquid::Tag

    def initialize(tag_name, markup, tokens)
      super
      @class = nil #not required
      @index = '0' #defaults to zero
      @caption = nil #not required

      #creating regular expression that grabs the index $2 at minimum, but optionally class and caption
      if markup =~ /(\S.*\s+)?(\d)+\s?(caption)?/i
        #entering at least one integer will validate the regular expression
        @class = $1
        @index = $2
        @caption = $3
      end
    end

    def render(context)
      # making sure that liquid tags referencing the front matter are parsed as liquid tags
      @site_url = Liquid::Template.parse("{{ site.image_url }}").render(context)
      @src = Liquid::Template.parse("{{ page.image[#{@index}] }}").render(context)
      @alt = Liquid::Template.parse("{{ page.image_alt[#{@index}] }}").render(context)
      @caption = Liquid::Template.parse("{{ page.image_caption[#{@index}] | markdownify }}").render(context) if @caption

      if @class
        figure = "<figure class=\"#{@class}\">"
      else
        figure = "<figure>"
      end

      figure += "<img src=\"#{@site_url}\/#{@src}\" alt=\"#{@alt}\"/>"
      
      if @caption
        figure += "<figcaption>#{@caption}</figcaption>"
        figure += "</figure>"
      else
        figure += "</figure>"
      end
    end
  end
end

Liquid::Template.register_tag('figure_img', Jekyll::FigureImageTag)