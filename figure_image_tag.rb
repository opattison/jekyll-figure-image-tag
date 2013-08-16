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
# 
# Make sure to have an image host specified in the _config.yml file:
# 
#   image_url: http://images.example.com/
# 
# Syntax: 
# {% figure_img [class name(s)] /path/to/image 'alt text' ['caption text'] %}
# 
# Sample (typical use): 
# {% figure_img left {{ page.image[0] }} {{ page.image_alt[0] }} {{ page.image_caption[0] }} %}
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
      @src = ''
      @alt = ''
      @caption = nil #not required

      if markup =~ /(\S.*\s+)?(page.image\[\d\])(\s+page.image_alt\[\d\])?(\s+page.image_caption\[\d\])?/
        #regex that grabs the src and alt at minimum, but optionally alt and caption
        @class = $1
        @src = $2
        @alt = $3
        @caption = $4
      end
    end

    def render(context)
      # making sure that liquid tags referencing the front matter are parsed as liquid tags
      @src = Liquid::Template.parse("{{ #{@src} }}").render(context)
      @alt = Liquid::Template.parse("{{ #{@alt} }}").render(context)
      @caption = Liquid::Template.parse("{{ #{@caption} | markdownify }}").render(context) if @caption
      @site_url = Liquid::Template.parse("{{ site.image_url }}").render(context)

      if @class
        figure = "<figure class=\"#{@class}\">"
      else
        figure = "<figure>"
      end

      figure += "<img src=\"#{@site_url}#{@src}\" alt=\"#{@alt}\"/>"
      
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