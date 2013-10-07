require 'spec_helper'

describe Script do

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

  describe 'body_lf' do
    context 'contains cr' do
      subject { Script.new(body: "new\r\nline") }
      its(:body_lf) { should == "new\nline" }
    end
  end

end
