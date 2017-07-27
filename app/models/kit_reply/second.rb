module KitReply
  class Second < Base
    def take_positive_action!
      user.handle_second_positive_kit_response
    end
  end
end
