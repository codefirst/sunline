require 'spec_helper'

describe Script do

  describe 'find' do

    it 'with nil' do
      Script.find.should be_nil
    end

  end

end
