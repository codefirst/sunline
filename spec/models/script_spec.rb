require 'spec_helper'

describe Script do

  describe 'find' do

    it 'with nil' do
      Script.find.should be_nil
    end

  end

  describe 'save' do
    before do
      @script = Script.new(name: 'name')
      @script.save
    end

    subject { @script }

    its(:guid) { should_not be_blank }
  end

  describe 'creater' do
    context 'user exists' do
      subject { Script.new(created_by: User.new(name: 'test user')) }
      its(:creater_name) { should == 'test user' }
    end
    context 'user not exists' do
      subject { Script.new }
      its(:creater_name) { should be_blank }
    end
  end

  describe 'updater' do
    context 'user exists' do
      subject { Script.new(updated_by: User.new(name: 'test user')) }
      its(:updater_name) { should == 'test user' }
    end
    context 'user not exists' do
      subject { Script.new }
      its(:updater_name) { should be_blank }
    end
  end

end
