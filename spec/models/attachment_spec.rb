require 'rails_helper'

describe Attachment do
  describe "download_command" do
    context "local filesystem" do
      before do
        upload = double
        allow(upload).to receive(:url) { "/filename.txt" }
        instance = double
        allow(instance).to receive(:upload_file_name) { "filename.txt" }
        allow(upload).to receive(:instance) { instance }
        @attachment = Attachment.new
        allow(@attachment).to receive(:upload) { upload }
      end
      subject { @attachment.download_command("http://example.com") }
      it { is_expected.to eq "curl -s -o 'filename.txt' 'http://example.com/filename.txt'" }
    end

    context "s3" do
      before do
        upload = double
        allow(upload).to receive(:url) { "http://foo.s3.amazonaws.com/attachments/uploads/000/000/000/original/filename.txt?00000000" }
        instance = double
        allow(instance).to receive(:upload_file_name) { "filename.txt" }
        allow(upload).to receive(:instance) { instance }
        @attachment = Attachment.new
        allow(@attachment).to receive(:upload) { upload }
      end
      subject { @attachment.download_command("http://example.com") }
      it { is_expected.to eq "curl -s -o 'filename.txt' 'http://foo.s3.amazonaws.com/attachments/uploads/000/000/000/original/filename.txt?00000000'" }
    end
  end
end
