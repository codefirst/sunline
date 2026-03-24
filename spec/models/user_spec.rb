require 'rails_helper'

describe User do
  let(:user) { User.new(name: 'test user', nickname: 'test') }

  describe 'attributes' do
    subject { user }
    its(:name) { is_expected.to eq 'test user' }
    its(:nickname) { is_expected.to eq 'test' }
  end

  describe 'validations' do
    it 'is valid with name and nickname' do
      expect(user).to be_valid
    end
  end
end
