class Attachment < ActiveRecord::Base
  belongs_to :script
  has_attached_file :upload
end
