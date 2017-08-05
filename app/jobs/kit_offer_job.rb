class KitOfferJob
  def initialize(logger, enumerator=User.kit_eligible)
    @logger = logger
    @enumerator = enumerator
  end

  def send_all
    working = true
    @logger.info 'Getting next_eligible...'
    while working
      next_user = next_eligible
      if next_user == nil
        @logger.info 'None eligible.'
        working = false
      else
        @logger.info 'Attempting one...'
        offer(next_user)
        @logger.info 'One attempted.'
      end
    end
  end

  private

  def next_eligible
    @enumerator.next
  rescue StopIteration
    nil
  end

  def offer(user)
    user.send_kit_conversation
  end
end
