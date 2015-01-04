require 'rails_helper'

describe ErrorsController, type: :controller do

  describe '#not_found' do
    it 'gets render' do
      get :not_found, code: 404
      expect(response).to render_template(:not_found)
    end
    it 'has 404 status' do
      get :not_found, code: 404
      expect(response.status).to eq(404)
    end
  end

  describe '#internal_error' do
    it 'gets render' do
      get :internal_error, code: 500
      expect(response).to render_template(:internal_error)
    end
    it 'has 404 status' do
      get :internal_error, code: 500
      expect(response.status).to eq(500)
    end
  end
end
