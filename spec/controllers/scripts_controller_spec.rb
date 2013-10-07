require 'spec_helper'

describe ScriptsController do

  before do
    user = User.new(name: 'name', nickname: 'nickname')
    user.save
    sign_in user
  end

  describe 'index' do
    context 'archived scripts' do
      before do
        @script = Script.new(name: 'name', archived: true)
        @script.save
        get :index, archived: 'true'
      end
      subject { assigns[:scripts].find {|script| script.id == @script.id } }
      it { should_not be_nil }
    end

    context 'active scripts' do
      before do
        @script = Script.new(name: 'name', archived: false)
        @script.save
        get :index
      end
      subject { assigns[:scripts].find {|script| script.id == @script.id } }
      it { should_not be_nil }
    end
  end

  context 'archive' do
    before do
      @script = Script.new(name: 'name', archived: nil)
      @script.save
      post :archive, id: @script.id
    end
    subject { Script.find(@script.id) }
    its(:archived) { should be_true }
  end

  context 'unarchive' do
    before do
      @script = Script.new(name: 'name', archived: true)
      @script.save
      post :unarchive, id: @script.id
    end
    subject { Script.find(@script.id) }
    its(:archived) { should be_false }
  end
end
