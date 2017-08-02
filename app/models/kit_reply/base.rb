module KitReply
  class Base
    attr_reader :user, :user_reply

    def initialize(user_reply, user)
      @user = user
      @user_reply = user_reply
    end

    def take_action!
      if user_reply == 'yes'
        take_positive_action!
      elsif user_reply == 'no'
        take_negative_action!
      else
        raise ArgumentError, 'Unknown user reply, should be yes or no, was: ' + user_reply.inspect
      end
    end

    def take_negative_action!
      user.handle_negative_kit_response
    end

    def take_positive_action!
      user.handle_positive_kit_response
    end
  end
end
