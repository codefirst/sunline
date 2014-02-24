require 'spec_helper'

describe Attachment do
  describe "download_command" do
    context "local filesystem" do
      before do
        upload = double
        upload.stub(:url) { "/filename.txt" }
        instance = double
        instance.stub(:upload_file_name) { "filename.txt" }
        upload.stub(:instance) { instance }
        @attachment = Attachment.new
        @attachment.stub(:upload) { upload }
      end
      subject { @attachment.download_command("http://example.com") }
      it { should == "curl -o 'filename.txt' 'http://example.com/filename.txt'" }
    end

    context "s3" do
      before do
        upload = double
        upload.stub(:url) { "http://foo.s3.amazonaws.com/attachments/uploads/000/000/000/original/filename.txt?00000000" }
        instance = double
        instance.stub(:upload_file_name) { "filename.txt" }
        upload.stub(:instance) { instance }
        @attachment = Attachment.new
        @attachment.stub(:upload) { upload }
      end
      subject { @attachment.download_command("http://example.com") }
      it { should == "curl -o 'filename.txt' 'http://foo.s3.amazonaws.com/attachments/uploads/000/000/000/original/filename.txt?00000000'" }
    end
  end
end
