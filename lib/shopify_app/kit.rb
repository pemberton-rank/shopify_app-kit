require "shopify_app/kit/version"
require "shopify_app/kit/engine"
require "shopify_app/kit/configuration"

module ShopifyApp
  module Kit
    def self.configure
      yield config
    end

    def self.config
      @config ||= ShopifyApp::Kit::Configuration.new
    end

    def self.config=(config)
      @config = config
    end
  end
end
