namespace :migrate_to_active_storage do
  desc 'migrate paperclip to active storage (database)'
  task db: :environment do |task|
    # this rake task works on postgresql only!!
    get_blob_id = 'LASTVAL()'

    ActiveRecord::Base.transaction do
      result = ActiveRecord::Base.connection.select_all(<<~SQL)
        SELECT id,
          upload_file_name,
          upload_content_type,
          upload_file_size,
          upload_updated_at
          FROM attachments ORDER BY id
      SQL

      result.rows.each do |id, upload_file_name, upload_content_type, upload_file_size, upload_updated_at|
        exec_query([
          <<~SQL,
          INSERT INTO active_storage_blobs (
            key, filename, content_type, metadata, byte_size, checksum, created_at, service_name
          ) VALUES (?, ?, ?, '{}', ?, ?, ?, 'amazon')
        SQL
          SecureRandom.uuid,
          upload_file_name,
          upload_content_type,
          upload_file_size,
          checksum(id, upload_file_name),
          upload_updated_at.iso8601
        ])

        exec_query([
          <<~SQL,
          INSERT INTO active_storage_attachments (
            name, record_type, record_id, blob_id, created_at
          ) VALUES (?, ?, ?, #{get_blob_id}, ?)
        SQL
          'upload',
          'Attachment',
          id,
          upload_updated_at.iso8601,
        ])
      end
    end
  end

  desc 'migrate paperclip to active storage (s3)'
  task s3: :environment do |task|
    Attachment.where.not(upload_file_name: nil).find_each do |attachment|
      # This step helps us catch any attachments we might have uploaded that
      # don't have an explicit file extension in the filename
      upload_url = file_uri(attachment.id, attachment.upload_file_name)
      attachment.upload.attach(io: URI.open(upload_url),
                               filename: attachment.upload_file_name,
                               content_type: attachment.upload_content_type)
    end
  end

  private

  def exec_query(args)
    sql = ActiveRecord::Base.sanitize_sql_array(args)
    ActiveRecord::Base.connection.execute(sql)
  end

  def file_uri(id, file_name)
    upload = CGI.unescape(file_name)
    subdir = format("%09<number>d", number: id).scan(/.{1,3}/).join('/')

    # this url pattern can be changed to reflect whatever service you use
    "https://#{ENV['AWS_BUCKET']}.s3.#{ENV['AWS_REGION']}.amazonaws.com/attachments/uploads/#{subdir}/original/#{upload}"
  end

  def checksum(id, file_name)
    Digest::MD5.base64digest(Net::HTTP.get(URI(file_uri(id, file_name))))
  end
end
