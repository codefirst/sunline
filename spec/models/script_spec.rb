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

end
