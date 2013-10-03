class Script < ActiveRecord::Base
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  before_create :generate_guid

  def self.find(*args)
    return nil if args.empty?
    where(guid: args.first).first || super
  end

  def generate_guid
    self.guid = SecureRandom.uuid
  end

  def creater_name
    return nil unless created_by
    created_by.name
  end

  def updater_name
    return nil unless updated_by
    updated_by.name
  end
end
