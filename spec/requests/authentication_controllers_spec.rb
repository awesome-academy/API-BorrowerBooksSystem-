require 'rails_helper'

RSpec.describe "AuthenticationControllers", type: :request do
  let(:body_response) {JSON.parse response.body, symbolize_names: true}
  let!(:user) {FactoryBot.create :user}

  describe "POST /login" do
    context "when valid parameters" do
      before :each do
        post login_path, params: {email: user.email, password: user.password}
      end

      it "return http ok" do
        expect(response).to have_http_status(:ok)
      end

      it "render JSON response" do
        token = JsonWebToken.encode(user_id: user.id)
        hash_response = {
          user: user.name,
          token: token
        }
        expect(body_response).to eq(hash_response)
      end
    end

    context "when invalid parameters" do
      before :each do
        post login_path
      end

      it "return http ok" do
        expect(response).to have_http_status(:unauthorized)
      end

      it "render JSON response" do
        expect(body_response).to eq({message: I18n.t("authenticate.invalid")})
      end
    end
  end
end
