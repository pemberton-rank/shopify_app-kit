class KitController < ActionController::Base
  def callback
    if auth_hash
      user = Shop.find_by(shopify_domain: auth_hash.info.myshopify_domain).user
      user.update kit_access_token: auth_hash.credentials.token, kit_user_id: auth_hash.info.id, first_name: auth_hash.info.first_name, last_name: auth_hash.info.last_name

      redirect_to ShopifyApp::Kit.config.after_login_url
    end
  end

  def conversation_callback
    render json: { products: [], metadata: {} }
    Thread.new do
      KitReply.new(params).take_action!
    end
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
