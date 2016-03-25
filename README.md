# [Not currently maintained – will respond to Issues]

This use case can be solved without plugins as well – try using Liquid/HTML `[includes](https://jekyllrb.com/docs/templates/#tags)`.

# Figure/image tag plugin for Jekyll

Oliver Pattison | https://olivermak.es

## What is it?

Create figure/img HTML elements with optional classes and captions. This is a YAML-dependent Liquid tag plugin for Jekyll for those who fear link rot.

### Note

This plugin is designed specifically for implementations with YAML front matter-based images, captions and alt text. Front matter-based images make sense if they are already a part of your workflow and post creation, but I realize that it is not a typical method for building Jekyll posts. You might want to adopt the approach if your goal is maintainable images with future-proofed URLs hosted in a single directory or bucket on a sub-domain for your Jekyll site.

## Setting up the plugin

Clone or download this repository. Add the **figure_image_tag.rb** file to your Jekyll _plugins folder. For more background and documentation on Jekyll plugins, [read the Jekyll docs](http://jekyllrb.com/docs/plugins/).

Create [YAML sequences](http://yaml4r.sourceforge.net/doc/page/collections_in_yaml.htm) (arrays) for your images in the post's front matter like this:

``` yaml
  image:
    - url: path/to/image
      caption: 'A photo from my trip to [the solar farm](http://example.com).'
      alt: 'alt text'
    - url: path/to/another-image
      caption: 'Another photo from my trip.' 
      alt: 'more alt text'
```

The values declared in the YAML front matter will be used by the plugin to insert images in the post.

In the markup, these are referred to with standard Jekyll Liquid variables. Each variable is identified with a zero-index counter in the variable pointing to the string in the front matter sequence (array), e.g. `page.image[0]` for the first item in the sequence. These front matter images are conveniently also reusable for other purposes such as homepage indexes.

### Why YAML is useful for storing images

If you haven't used YAML sequences like this, you may be wondering why you'd want to store image URLs and metadata in the front matter. One advantage is that the syntax for marking (down) images is always the same (`page.tag[i].attribute`) no matter what post you're editing. Abstracting images outside of the post content body decreases possible errors for content editors since the syntax remains the same. Additionally, the photo URL and metadata are inextricably tied to that post, which could have value if you are maintaining a large project or doing content inventory.

*Make sure to have an image host specified in the _config.yml file.* Example:

  `image_url: http://static.example.com/images`

Assuming that all image URLs are all hosted from the same source, the image URL for the site leads the post's image file name like this: `{{ site.image_url }}/{{ page.image[3].url }}` while automatically populating the `alt` attributes. This arrangement is convenient if you have your images hosted elsewhere (sub-domain, S3, etc.). Currently the plugin does not support a different configuration for other types of image URLs, but this could be modified or forked.

## Let's see it working, then

**The syntax:**

`{% figure_img [class name(s)] integer [caption] %}`

Here are some samples to use inline in markdown Jekyll posts:

Sample (no classes or captions):

`{% figure_img 1 %}`

Sample (typical use):

`{% figure_img left 0 caption %}`

Sample output:

``` html
<figure class="left">
  <img src="http://images.example.com/solar-farm.jpg" alt="Landscape view of solar farm">
  <figcaption>
    <p>A photo from my trip to <a href="http://example.com">the solar farm</a>.</p>
  </figcaption>
</figure>
```

The integer value that you pick determines which image (and alt and caption) will be picked from the YAML sequence. Starting at 0 and counting through the sequence, this index value refers to the front matter.

The caption is an optional element that you can include with "caption" or exclude by entering no value after the index.

By the way, the figcaption element can process markdown for hyperlinks – useful! The optional classes are useful for common needs like right/left aligning figures, or any other CSS you can imagine.

## Why Figure?

[Figure](http://dev.w3.org/html5/markup/figure.html) is an element introduced in the HTML5 spec that allows for semantically separated content (such as a photo or graph) that is directly related to the content of a document (unlike an `<aside>`). It may contain a descriptive caption called a `<figcaption>`. Or as the W3C spec puts it:

> The figure element represents a unit of content, optionally with a caption, that is self-contained, that is typically referenced as a single unit from the main flow of the document, and that can be moved away from the main flow of the document without affecting the document’s meaning.
[source](http://dev.w3.org/html5/markup/figure.html)

Figures provide a solid, semantic way to contain an image related to an article and add a substantial descriptive caption. I imagine that it would be particularly useful for enhancing writing that has a scientific focus.

[More reading from the W3C spec](http://www.whatwg.org/specs/web-apps/current-work/multipage/grouping-content.html#the-figure-element) and the [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/figure).

## Alternative image plugins for Jekyll

- [Jekyll Picture Tag (responsive images)](https://github.com/robwierzbowski/jekyll-picture-tag)
- [Jekyll Image Tag](https://github.com/robwierzbowski/jekyll-image-tag)
- [Octopress Image Tag](https://github.com/imathis/octopress/blob/master/plugins/image_tag.rb)
- [Image tag by Stewart (also uses figure)](https://github.com/stewart/blog/blob/master/plugins/image_tag.rb)

## Notes

- I first developed the plugin for [this Jekyll project](https://github.com/opattison/jeancflanagan) so I could use `<figure>` without writing HTML blocks every time.
- Thanks to other [Jekyll plugin developers](http://jekyllrb.com/docs/plugins/) for open sourcing and documenting their plugins so I could borrow and learn.
- Read more about [YAML sequences](http://yaml4r.sourceforge.net/doc/page/collections_in_yaml.htm).
