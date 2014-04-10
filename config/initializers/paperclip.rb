if ENV['PAPERCLIP_STORAGE_TYPE'] == 's3'
  Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
  Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
  Paperclip::Attachment.default_options[:s3_protocol] = 'https'
end
