require 'rails_helper'

describe Log do
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
      Log.create(host: 'a.example.net')
      Log.create(host: 'a.example.net')
      Log.create(host: 'b.example.net')
    end
    subject { Log.all_hosts }
    it { is_expected.to match_array ['a.example.net', 'b.example.net'] }
  end

  context "select by host" do
    before do
      Log.delete_all
      Log.create(host: 'a.example.net')
      Log.create(host: 'a.example.net')
      Log.create(host: 'b.example.net')
    end
    subject { Log.by_host('a.example.net') }
    it { is_expected.to have(2).items }
  end

  context 'set result_bytes automatically' do
    subject { Log.create(result: result) }

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
