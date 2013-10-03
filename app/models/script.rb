class Script < ActiveRecord::Base
  before_create :generate_guid

  def self.find(*args)
    return nil if args.empty?
    where(guid: args.first).first || super
  end

  def generate_guid
    self.guid = SecureRandom.uuid
  end
end
