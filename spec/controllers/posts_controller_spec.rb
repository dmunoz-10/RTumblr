require 'rails_helper'
require 'jwt'

RSpec.describe Api::V1::PostsController, type: :controller do
  context 'when user is authenticated' do
    before do
      token = JWT.encode({user: User.first.id},
                         Rails.application.secrets.secret_key_base, 'HS256')
    end

    it '' do

    end
  end
end
