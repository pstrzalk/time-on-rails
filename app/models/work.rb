class Work < ApplicationRecord
  belongs_to :project

  def start
    return if started

    self.started = DateTime.current
  end

  def stop
    self.duration = duration + (DateTime.current.to_time - started).to_i
    self.started = nil
  end
end
