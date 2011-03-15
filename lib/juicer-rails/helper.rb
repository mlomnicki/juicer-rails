require 'juicer-rails/collection'

module Juicer::Helper

  def merged_javascripts(key, options = {})
    javascript_include_tag(Juicer::Collection.dispatch(key, 'js'), options)
  end

  def merged_stylesheets(key, options = {})
    stylesheet_link_tag(Juicer::Collection.dispatch(key, 'css'), options)
  end

end

ActionView::Base.send(:include, Juicer::Helper)
