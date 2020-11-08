# frozen_string_literal: true

module Command
  def self.save(record)
    record.tap(&:save!)
  end

  def self.destroy(record)
    record.tap(&:destroy!)
  end
end
