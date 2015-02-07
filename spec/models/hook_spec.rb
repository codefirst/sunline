require 'rails_helper'

describe Hook do
  describe 'belongs to script' do
    before do
      @hook = Hook.create!
      @script = Script.create!(name: 'name')
      @script.hooks << @hook
    end
    subject { @script.hooks.first }
    it { is_expected.to eq @hook }
  end
end
