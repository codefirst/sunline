require 'spec_helper'

describe Log do
  context "belongs to a Script" do
    before do
      @script = Script.new(name: 'script name', body: 'ls')
      @log = Log.new(host: '0.0.0.0')
      @script.logs << @log
    end
    subject { @script.logs }
    its(:size) { should == 1 }
  end
end
