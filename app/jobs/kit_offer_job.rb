class KitOfferJob
  def initialize(logger)
    @logger = logger
    @eligible = User.kit_eligible
  end

  def send_one
    @logger.info 'Getting next_eligible...'
    next_user = next_eligible
    if next_user == nil
      @logger.info 'None eligible.'
      return false
    else
      @logger.info 'Attempting one...'
      offer(next_user)
      @logger.info 'One attempted.'
      return true
    end
  end

  private

  def next_eligible
    @eligible.next
  rescue StopIteration
    nil
  end

  def offer(user)
    # user.send_first_step_kit_conversation
    puts user.inspect
  end
end
