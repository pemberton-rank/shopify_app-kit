describe "KitEligible", type: :model do
  let(:subject) { User.new }
  before :each do
    User.delete_all
  end

  describe 'gem API' do
    it do
      expect(subject.methods).to include(
        :handle_positive_kit_response,
        :handle_negative_kit_response,
        :after_send_kit_conversation,
        :kit_placeholders,
        :send_kit_conversation
      )

      expect(subject.class.methods).to include :kit_eligible
    end
  end

  describe '.kit_eligible' do
    let(:subject) { User }
    let!(:eligible_user) { FactoryGirl.create(:user, kit_access_token: 'something') }
    let!(:noneligible_user) { FactoryGirl.create(:user, kit_access_token: nil) }

    it 'returns enum' do
      expect(subject.kit_eligible.class).to eq Enumerator
    end

    it 'contains users that are kit eligible' do
      expect(subject.kit_eligible).to contain_exactly eligible_user
    end
  end

  describe '#kit' do
    it 'is Faraday instance' do
      expect(subject.kit.class).to eq Faraday::Connection
    end
  end

  describe '#send_kit_conversation' do
    before :each do
      ShopifyApp::Kit.config.conversation_id = 153
      stub_request(:any, "https://www.kitcrm.com/api/v1/conversations/153/start")
      allow(subject).to receive(:kit_placeholders) { {name: 'Anton Murygin'} }
    end
    it 'sends special request to Kit' do
      subject.send_kit_conversation
      expect(WebMock).to have_requested(:post, "https://www.kitcrm.com/api/v1/conversations/#{ShopifyApp::Kit.config.conversation_id}/start").
        with(body: '{ "conversation": { "placeholders": {"name":"Anton Murygin"} } }',
        headers: {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.12.2'})
    end

    it 'calls after_send_kit_conversation' do
      allow(subject).to receive(:after_send_kit_conversation)
      subject.send_kit_conversation
      expect(subject).to have_received(:after_send_kit_conversation)
    end
  end

  describe '#take_kit_action!' do
    it 'calls handle_positive_kit_response action if yes' do
      allow(subject).to receive(:handle_positive_kit_response)
      subject.take_kit_action!("yes")
      expect(subject).to have_received(:handle_positive_kit_response)
    end

    it 'calls handle_negative_kit_response action if no' do
      allow(subject).to receive(:handle_negative_kit_response)
      subject.take_kit_action!("no")
      expect(subject).to have_received(:handle_negative_kit_response)
    end

    it 'raises if other' do
      expect{subject.take_kit_action!("whatever")}.to raise_error ArgumentError, 'Unknown user reply, should be yes or no, was: "whatever"'
    end
  end
end
