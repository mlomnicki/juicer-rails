require 'yaml'

module JuicerRails

  class Railtie < Rails::Railtie

    initializer "juicer_rails.init" do
      ::JuicerRails.setup do |juicer|
        juicer.config_file ||= Rails.root.join('config/assets.yml')
        juicer.config ||= YAML.load_file(juicer.config_file)
      end
    end

  end

end
