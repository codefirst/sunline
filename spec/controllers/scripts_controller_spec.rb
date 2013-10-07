require 'spec_helper'

describe ScriptsController do

  before do
    user = User.new(name: 'name', nickname: 'nickname')
    user.save
    sign_in user
  end

  context 'archive' do
    before do
      @script = Script.new(name: 'name', archived: nil)
      @script.save
      post :archive, :id => @script.id
    end
    subject { Script.find(@script.id) }
    its(:archived) { should be_true }
  end
end
