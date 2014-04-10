require 'spec_helper'

describe Script do

  describe '' do
    before do
      @script = Script.new(name: 'foo')
      @script.save
      @guid = @script.guid
    end

    subject { @script.remote_script("http://localhost:3000/") }

    it { should eq "curl -s http://localhost:3000/scripts/#{@guid}.sh | sh > sunline.log 2>&1;curl -s http://localhost:3000/scripts/#{@guid}/log -X POST -F host=`hostname` -F log_file=@sunline.log" }
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

  describe 'body_lf' do
    context 'contains cr' do
      subject { Script.new(body: "new\r\nline") }
      its(:body_lf) { should == "new\nline" }
    end
  end

end
