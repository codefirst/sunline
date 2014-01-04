require 'spec_helper'

describe Hook do
  describe 'belongs to script' do
    before do
      @hook = Hook.create!
      @script = Script.create!(name: 'name')
      @script.hooks << @hook
    end
    subject { @script.hooks.first }
    it { should eq @hook }
  end
end
