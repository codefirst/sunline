require 'rails_helper'

describe Script do

  describe '' do
    before do
      @script = Script.new(name: 'foo')
      @script.save
      @guid = @script.guid
    end

    subject { @script.remote_script("http://localhost:3000/") }

    it { is_expected.to eq "curl -s http://localhost:3000/scripts/#{@guid}.sh | sh 2>&1 | tee sunline.log;curl -s http://localhost:3000/scripts/#{@guid}/log -X POST -F host=`hostname` -F log_file=@sunline.log" }
  end

  describe 'save' do
    before do
      @script = Script.new(name: 'name')
      @script.save
    end

    subject { @script }

    its(:guid) { is_expected.not_to be_blank }
  end

  describe 'creater' do
    context 'user exists' do
      subject { Script.new(created_by: User.new(name: 'test user')) }
      its(:creater_name) { is_expected.to eq 'test user' }
    end
    context 'user not exists' do
      subject { Script.new }
      its(:creater_name) { is_expected.to be_blank }
    end
  end

  describe 'updater' do
    context 'user exists' do
      subject { Script.new(updated_by: User.new(name: 'test user')) }
      its(:updater_name) { is_expected.to eq 'test user' }
    end
    context 'user not exists' do
      subject { Script.new }
      its(:updater_name) { is_expected.to be_blank }
    end
  end

  describe 'body_lf' do
    context 'contains cr' do
      subject { Script.new(body: "new\r\nline") }
      its(:body_lf) { is_expected.to eq "new\nline" }
    end
  end

  describe 'search' do
    script = Script.new(name: "ls", body: "ls -la")
    script.save

    subject { Script.search("ls").first }
    its(:body) { is_expected.to include "ls" }
  end

end
