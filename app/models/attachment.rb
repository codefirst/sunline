class Attachment < ApplicationRecord
  belongs_to :script, touch: true
  has_one_attached :upload

  def download_command(root_url)
      url = self.upload.url
      url = root_url + url if url.start_with?('/')
      filename = self.upload.filename.to_s
      "curl -s -o '#{filename}' '#{url}'"
  end
end
