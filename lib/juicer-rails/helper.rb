require 'juicer-rails/collection'

module Juicer::Helper

  def merged_javascripts(key)
    javascript_include_tag(Juicer::Collection.merge(key, 'js'))
  end

  def merged_stylesheets(key)
    stylesheet_link_tag(Juicer::Collection.merge(key, 'css'))
  end

end

ActionView::Base.send(:include, Juicer::Helper)
