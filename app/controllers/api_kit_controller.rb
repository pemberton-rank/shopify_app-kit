class ApiKitController < ActionController::Base
  include PR::Common::TokenAuthenticable

  def destroy
    current_user.update kit_access_token: nil
    render json: current_user, serializer: SessionSerializer
  end
end
