module KitReply
  def self.new(params)
    if params[:conversation_id].to_s == ShopifyApp::Kit.config.first_conversation_id.to_s
      KitReply::First.new(params)
    elsif params[:conversation_id].to_s == ShopifyApp::Kit.config.second_conversation_id.to_s
      KitReply::Second.new(params)
    else
      raise ArgumentError, 'No such conversation!'
    end
  end
end
