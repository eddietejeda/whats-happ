require 'spec_helper'

describe IncomingMessagesController do
  describe 'POST create' do
    let(:phone) { '+16025555555' }

    before do
      user = ENV.fetch('TWILIO_MESSAGES_NAME')
      password = ENV.fetch('TWILIO_MESSAGES_PASSWORD')
      request.env['HTTP_AUTHORIZATION'] =
        ActionController::HttpAuthentication::Basic.encode_credentials(user,password)
    end

    context 'SMS filtering' do

      IncomingMessagesController::FILTER_WORDS.each do |flag|
        context(flag) do
          let(:params) {{
            'Body' => flag,
            'From' => phone
          }}

          it 'marks all subscriptions with that number as unsubscribed' do
            create(:subscription, phone: phone)
            create(:subscription, phone: phone)
            expect { post :create, params }.to change{ Subscription.active.count }.by(-2)
          end
        end
      end

    end
  end
end
