require 'rails_helper'

describe ScriptsController, type: :controller  do
  let(:sign_in_user) { User.create!(name: 'name', nickname: 'nickname') }

  before do
    sign_in sign_in_user
  end

  describe 'index' do
    context 'archived scripts' do
      before do
        @script = Script.new(name: 'name', archived: true, created_by: sign_in_user, updated_by: sign_in_user)
        @script.save
        get :index, params: { archived: 'true' }
      end
      subject { controller.instance_variable_get("@scripts").find {|script| script.id == @script.id } }
      it { is_expected.not_to be_nil }
    end

    context 'active scripts' do
      before do
        @script = Script.new(name: 'name', archived: false, created_by: sign_in_user, updated_by: sign_in_user)
        @script.save
        get :index
      end
      subject { controller.instance_variable_get("@scripts").find {|script| script.id == @script.id } }
      it { is_expected.not_to be_nil }
    end
  end

  context 'archive' do
    before do
      @script = Script.new(name: 'name', archived: nil, created_by: sign_in_user, updated_by: sign_in_user)
      @script.save
      post :archive, params: { id: @script.id }
    end
    subject { Script.find(@script.id) }
    its(:archived) { is_expected.to be_truthy }
  end

  context 'unarchive' do
    before do
      @script = Script.new(name: 'name', archived: true, created_by: sign_in_user, updated_by: sign_in_user)
      @script.save
      post :unarchive, params: { id: @script.id }
    end
    subject { Script.find(@script.id) }
    its(:archived) { is_expected.to be_falsy }
  end

  context 'runnable_script' do
    before do
      @script = Script.new(name: 'name', body: 'ls -l', created_by: sign_in_user, updated_by: sign_in_user)
      @script.save
      get :sh, params: { guid: @script.guid }
    end
    it { expect(response.body).to be_include 'ls -l' }
  end

  context 'remote_script' do
    before do
      @script = Script.new(name: 'name', body: 'ls -l', created_by: sign_in_user, updated_by: sign_in_user)
      @script.save
      get :wrapped_sh, params: { guid: @script.guid }
    end
    it { expect(response.body).to be_include 'tee' }
  end

  describe 'logs' do
    before do
      @script = Script.new(name: 'name', body: 'ls -l', created_by: sign_in_user, updated_by: sign_in_user)
      @script.save
    end

    context 'without logs' do
      it 'returns empty JSON' do
        get :logs, params: { id: @script.id }
        json = JSON.parse(response.body)
        expect(json['logs']).to eq([])
        expect(json['count']).to eq(0)
      end
    end

    context 'with logs' do
      before do
        @log = Log.create!(script: @script, host: 'server1', result: 'output data')
      end

      it 'returns logs as JSON' do
        get :logs, params: { id: @script.id }
        json = JSON.parse(response.body)
        expect(json['count']).to eq(1)
        expect(json['logs'].first['host']).to eq('server1')
        expect(json['logs'].first['id']).to eq(@log.id)
        expect(json['logs'].first['url']).to eq("/logs/#{@log.id}")
      end

      it 'returns highlighted: true for matching keyword' do
        get :logs, params: { id: @script.id, keyword: 'output' }
        json = JSON.parse(response.body)
        expect(json['logs'].first['highlighted']).to eq(true)
      end

      it 'returns highlighted: false for non-matching keyword' do
        get :logs, params: { id: @script.id, keyword: 'nomatch' }
        json = JSON.parse(response.body)
        expect(json['logs'].first['highlighted']).to eq(false)
      end

    end

    context 'with delta mode' do
      before do
        @log1 = Log.create!(script: @script, host: 'server1', result: 'first log')
        @log2 = Log.create!(script: @script, host: 'server2', result: 'second log')
      end

      it 'returns only logs newer than since_id' do
        get :logs, params: { id: @script.id, since_id: @log1.id }
        json = JSON.parse(response.body)
        expect(json['logs'].map { |l| l['id'] }).to eq([@log2.id])
      end

      it 'returns total count not delta count' do
        get :logs, params: { id: @script.id, since_id: @log1.id }
        json = JSON.parse(response.body)
        expect(json['count']).to eq(2)
      end

      it 'highlights only new log that matches keyword' do
        get :logs, params: { id: @script.id, since_id: @log1.id, keyword: 'second' }
        json = JSON.parse(response.body)
        expect(json['logs'].first['highlighted']).to eq(true)
      end

      it 'returns highlighted: false when keyword matches only old log' do
        get :logs, params: { id: @script.id, since_id: @log1.id, keyword: 'first' }
        json = JSON.parse(response.body)
        expect(json['logs'].first['highlighted']).to eq(false)
      end
    end
  end

  context 'search_script' do
    describe 'with keyword' do
      before do
        @script = Script.new(name: 'name', body: 'ls -l', created_by: sign_in_user, updated_by: sign_in_user)
        @script.save
        get :search, params: { keyword: 'ls' }
      end
      subject { controller.instance_variable_get("@scripts").find {|script| script.id == @script.id } }
      it { is_expected.not_to be_nil }
    end
  end

end
