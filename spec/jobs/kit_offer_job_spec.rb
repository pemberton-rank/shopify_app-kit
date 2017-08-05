describe KitOfferJob do
  describe '#send_all' do
    let(:doubles) {[
      instance_double("User"),
      instance_double("User")
    ].to_enum}

    before do
      allow(User).to receive(:kit_eligible).and_return(doubles)
    end

    it 'sends offer to all users' do
      expect(doubles).to all receive :send_kit_conversation
      KitOfferJob.new(Logger.new(STDOUT)).send_all
    end
  end
end
