require 'rails_helper'

describe Log do
  let(:user) { User.create!(name: 'name', nickname: 'nickname') }
  let(:script) { Script.create!(name: 'script name', body: 'ls', created_by: user, updated_by: user) }

  context "belongs to a Script" do
    before do
      @script = Script.new(name: 'script name', body: 'ls')
      @log = Log.new(host: '0.0.0.0')
      @script.logs << @log
    end
    subject { @script.logs }
    its(:size) { is_expected.to eq 1 }
  end

  context "get all hosts" do
    before do
      Log.delete_all
      Log.create(host: 'a.example.net', script: script)
      Log.create(host: 'a.example.net', script: script)
      Log.create(host: 'b.example.net', script: script)
    end
    subject { Log.all_hosts }
    it { is_expected.to match_array ['a.example.net', 'b.example.net'] }
  end

  context "select by host" do
    before do
      Log.delete_all
      Log.create(host: 'a.example.net', script: script)
      Log.create(host: 'a.example.net', script: script)
      Log.create(host: 'b.example.net', script: script)
    end
    subject { Log.by_host('a.example.net') }
    it { is_expected.to have(2).items }
  end

  context 'set result_bytes automatically' do
    subject { Log.create(result: result, script: script) }

    context 'have result' do
      let(:result) { 'a result' }

      it { is_expected.to have_attributes(result_bytes: result.size) }
    end

    context 'not have result' do
      let(:result) { nil }

      it { is_expected.to have_attributes(result_bytes: 0) }
    end
  end
end
