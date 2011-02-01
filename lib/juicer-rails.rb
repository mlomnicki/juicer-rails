require 'juicer-rails/version'
require 'juicer-rails/helper'
require 'juicer-rails/railtie' if defined?(Rails::Railtie)

module JuicerRails

  # location of configuration files
  mattr_accessor :config_file
  # Rails 3 set this with Railtie. Rails.root is nil at this stage
  # Rails 2 has Rails.root defined so we can use it
  @@config_file = Rails.root.join('config/assets.yml') if Rails.root

  mattr_accessor :config
  @@config = YAML.load_file(config_file) if config_file

  # Current environment
  mattr_accessor :environment
  @@environment = Rails.env 

  # Which environments triggers assets compilations
  mattr_accessor :compile_environments
  @@compile_environments = %w[production]

  # Always compile assets
  mattr_accessor :always_compile
  @@always_compile = false

  # relative path from RAILS_ROOT/public where compiled assets are stored
  mattr_accessor :compiled_assets_directory
  @@compiled_assets_directory = 'assets'

  def self.perform_compilation?
    always_compile || compile_environments.include?(environment)
  end

  def self.setup
    yield self
  end

  def self.warn(text)
    ActiveSupport::Deprecation.warn("** JUICER-RAILS: #{text}")
  end

end

ActionView::Base.send(:include, Juicer::Helper)
