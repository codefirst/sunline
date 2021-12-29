class Attachment < ApplicationRecord
  belongs_to :script
  has_attached_file :upload
  do_not_validate_attachment_file_type :upload

  def download_command(root_url)
      url = self.upload.url
      url = root_url + url if url.start_with?('/')
      filename = self.upload.instance.upload_file_name
      "curl -s -o '#{filename}' '#{url}'"
  end
end
