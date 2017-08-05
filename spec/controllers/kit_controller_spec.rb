require 'rails_helper'

RSpec.describe KitController, type: :controller do
  include RSpec::Benchmark::Matchers
  before { load_files }
  let!(:shop) { FactoryGirl.create(:shop, shopify_domain: 'example.myshopify.com') }
  let!(:user) { FactoryGirl.create(:user, kit_user_id: 1234, shop_id: shop.id, access_token: 'abc') }

  describe 'POST #conversation_callback' do
    let(:expected_json) { { "products" => [], "metadata" => {} } }

    context 'if good params given' do
      let(:request_params) {
        {
          "user_id" => user.kit_user_id,
          "conversation_id" => 5,
          "user_conversation_id" => 3486,
          "user_reply" => "yes"
        }
      }

      it 'should return the correct response' do
        post :conversation_callback, {
          params: request_params
        }

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to match(expected_json)
      end

      it 'should return the response very fast, like within 3 sec' do
        expect {
          post :conversation_callback, {
            params: request_params
          }
        }.to perform_under(0.5).sec.and_sample(3)
      end

      it 'should run #take_action! on KitReply' do
        allow_any_instance_of(User).to receive(:handle_positive_kit_response) { raise ArgumentError, 'Test' }

        post :conversation_callback, {
          params: request_params
        }

        expect{$kit_reply_thread.join}.to raise_error ArgumentError, "Test"
      end
    end

    context 'wrong user id' do
      let(:request_params) {
        {
          "user_id" => "0000",
          "conversation_id" => 5,
          "user_conversation_id" => 3486,
          "user_reply" => "yes"
        }
      }

      it 'still renders good response' do
        post :conversation_callback, {
          params: request_params
        }

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to match(expected_json)
      end
    end
  end

  describe 'POST #callback' do
    context 'auth_hash given' do
      let(:auth_hash) {
        double('auth_hash', {
          info: double('info', {
            myshopify_domain: 'example.myshopify.com',
            first_name: 'Anton',
            last_name: 'Murygin',
            id: '1234'
          }),
          credentials: double('credentials', {
            token: 'tokentokentoken'
          })
        })
      }

      before :each do
        controller.request.env['omniauth.auth'] = auth_hash
        ShopifyApp::Kit.config.after_login_url = '/'
      end

      it 'updates user with kit info' do
        post :callback

        expect(user.reload.kit_user_id).to eq '1234'
        expect(user.kit_access_token).to eq 'tokentokentoken'
        expect(user.first_name).to eq 'Anton'
        expect(user.last_name).to eq 'Murygin'
        expect(response).to redirect_to('/')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { FactoryGirl.create(:user, kit_user_id: 1234, kit_access_token: '1234', shop_id: shop.id, access_token: 'abc') }
    let(:expected_json) { { "kit_access_token" => nil, "id" => user.id } }
    before :each do
      controller.request.headers['Authorization'] = user.access_token
    end

    it 'removes kit info from user' do
      delete :destroy
      expect(user.reload.kit_access_token).to eq nil
      expect(JSON.parse(response.body)).to match(hash_including(expected_json))
    end
  end
end
