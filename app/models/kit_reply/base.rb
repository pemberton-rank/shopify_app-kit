module KitReply
  class Base
    def initialize(params)
      @user_id = params[:user_id]
      @user_reply = params[:user_reply]
    end

    def user
      @_user ||= User.find_by_kit_user_id(@user_id)
    end

    def take_action!
      if @user_reply == 'yes'
        take_positive_action!
      elsif @user_reply == 'no'
        take_negative_action!
      else
        raise ArgumentError, 'Unknown user reply, should be yes or no, was: ' + @user_reply.inspect
      end
    end

    def take_negative_action!
      user.handle_negative_kit_response
    end
  end
end
