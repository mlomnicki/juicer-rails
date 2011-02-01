require 'juicer'
require 'fileutils'

class Juicer::Collection

  class << self
    extend ActiveSupport::Memoizable

    def dispatch(key, type)
      if JuicerRails.perform_compilation?
        compile(key, type)
      else
        embed_standalone(key, type)
      end
    end

    def compile(key, type)
      self.new(key, type).compile 
      destination_compiled_path(key, type).to_s
    end
    memoize :compile

    # Embeds each asset as standalone file.
    # The best mode for development purposes. No merging occurs
    def embed_standalone(key, type)
      dir = case type.to_s
            when 'js' then 'javascripts'
            when 'css' then 'stylesheets'
            end
      new(key, type).paths.collect { |p| Rails.root.join(p).relative_path_from(public_path.join(dir)).to_s }
    end

    def compiled_directory
      public_path.join(JuicerRails.compiled_assets_directory)
    end

    def compiled_path(key, type)
      compiled_directory.join("#{key}.#{type}")
    end

    def relative_compiled_path(key, type)
      compiled_path(key, type).relative_path_from(public_path)
    end

    def destination_compiled_path(key, type)
      "/#{relative_compiled_path(key, type)}"
    end

    def public_path
      @public_path ||= Rails.root.join('public')
    end

  end

  attr_reader :paths

  def initialize(key, type, options = {})
    @type = type
    @key = key
    @paths = JuicerRails.config[type.to_s][key.to_s]
    unless @paths.is_a?(Array)
      JuicerRails.warn("Wrong configuration for '#{key}'. Check you config file")
      @paths = []
    end
    @destination_dir = self.class.compiled_directory
    @destination_path = self.class.compiled_path(key, type)
    ensure_destination_directory_exists
  end

  # Produces production ready assets.
  # Merges, appends timestamps for images, embeds images into stylesheets
  # and tries to do everything what juicer can.
  # TODO: only merging and cache buster are implemented at the moment
  def compile
    merge
    bust_cache if @type == 'css'
  end

  # Depending on type merges and saves compiled asset
  def merge
    if @type == 'js'
      merger = merge_javascripts
    elsif @type == 'css'
      merger = merge_stylesheets
    end
    save(merger)
    self
  end

  def merge_javascripts
    Juicer::Merger::JavaScriptMerger.new(@paths)
  end

  def merge_stylesheets
    Juicer::Merger::StylesheetMerger.new(@paths, :document_root => Rails.root.join('public/stylesheets'))
  end

  def save(compiler)
    compiler.save(@destination_path.to_s)
    self
  end

  def bust_cache
    Juicer::CssCacheBuster.new.save(@destination_path.to_s)
    self
  end

  def ensure_destination_directory_exists
    unless @destination_dir.exist?
      FileUtils.mkdir_p(@destination_dir.to_s)
    end
  end

end
