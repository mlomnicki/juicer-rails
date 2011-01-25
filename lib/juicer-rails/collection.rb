require 'juicer'
require 'yaml'

class Juicer::Collection

  @@config_file = Rails.root.join('config/assets.yml')
  @@yaml = YAML.load_file(@@config_file)

  class << self
    extend ActiveSupport::Memoizable

    unless Rails.env.development?

      def merge(key, type)
        merged_path = path(key, type)
        unless merged_path.exist?
          merger = new(key, type).merge
          merger.bust_cache if type == 'css'

        end
        "/assets/#{key}.#{type}"
      end
      memoize :merge

    else

      def merge(key, type)
        dir = case type.to_s
              when 'js': 'javascripts'
              when 'css': 'stylesheets'
              end
        new(key, type).paths.collect { |p| Rails.root.join(p).relative_path_from(Rails.root.join('public', dir)).to_s }
      end

    end

    def path(key, type)
      Rails.root.join("public/assets/#{key}.#{type}")
    end

  end

  attr_reader :paths

  def initialize(key, type, options = {})
    @type = type
    @key = key
    @paths = @@yaml[type.to_s][key.to_s]
  end

  def merge
    if @type == 'js'
      merger = Juicer::Merger::JavaScriptMerger.new(@paths)
    elsif @type == 'css'
      merger = Juicer::Merger::StylesheetMerger.new(@paths, :document_root => Rails.root.join('public/stylesheets'))
    end
    merger.save(self.class.path(@key, @type).to_s)
    self
  end

  def bust_cache
    Juicer::CssCacheBuster.new.save(self.class.path(@key, @type).to_s)
  end

end
