module KitReply
  class First < Base
    def take_positive_action!
      user.handle_first_positive_kit_response
    end
  end
end
