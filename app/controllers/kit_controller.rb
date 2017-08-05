class KitController < ActionController::Base
  require 'active_model_serializers'
  include PR::Common::TokenAuthenticable
  skip_before_action :authenticate_user_from_token!, only: [:callback, :conversation_callback]

  def callback
    if auth_hash
      user = Shop.find_by!(shopify_domain: auth_hash.info.myshopify_domain).user
      user.update kit_access_token: auth_hash.credentials.token, kit_user_id: auth_hash.info.id, first_name: auth_hash.info.first_name, last_name: auth_hash.info.last_name

      redirect_to ShopifyApp::Kit.config.after_login_url
    end
  end

  def conversation_callback
    @user = User.find_by_kit_user_id(params[:user_id])
    render json: { products: [], metadata: {} }
    thread = Thread.new do
      @user.take_kit_action!(params[:user_reply])
    end

    expose_thread_for_testing_purposes(thread)
  end

  def destroy
    current_user.update kit_access_token: nil
    render json: current_user, serializer: SessionSerializer
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

  def expose_thread_for_testing_purposes(thread)
    $kit_reply_thread = thread
  end
end
