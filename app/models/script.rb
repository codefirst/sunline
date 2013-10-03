class Script < ActiveRecord::Base
  def self.find(*args)
    return nil if args.empty?
    where(guid: args.first).first || super
  end
end
