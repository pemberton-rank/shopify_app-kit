module KitEligible
  extend ActiveSupport::Concern

  module ClassMethods
    def kit_eligible
      Enumerator.new do |yielder|
        all.each do |user|
          if user.kit_eligible?
            yielder << user
          end
        end
      end
    end
  end

  def kit_eligible?
    kit_connected?
  end

  def kit
    headers = {
      'Authorization' => "Bearer #{self.kit_access_token}",
      'Accept'       => 'application/json',
      'Content-Type' => 'application/json',
    }
    Faraday.new(:url => "https://www.kitcrm.com/", headers: headers) do |conn|
      conn.response :json, :content_type => /\bjson$/

      conn.adapter Faraday.default_adapter
    end
  end

  def send_kit_conversation
    placeholders = prepare_placeholders(kit_placeholders)
    kit.post("/api/v1/conversations/#{ShopifyApp::Kit.config.conversation_id}/start", '{ "conversation": { "placeholders": { "shop_owner_first_name": "' + self.first_name + '" } } }')
    self.after_send_kit_conversation
  end

  def after_send_kit_conversation ;end

  def kit_placeholders; {}; end

  def prepare_placeholders(hash)
    JSON.generate(hash)
  end

  def kit_connected?
    self.kit_access_token.present?
  end
end
