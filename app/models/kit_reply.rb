module KitReply
  def self.new(params)
    if params[:conversation_id].to_s == ShopifyApp::Kit.config.conversation_id.to_s
      KitReply::Base.new(params)
    else
      raise ArgumentError, 'No such conversation!'
    end
  end
end
