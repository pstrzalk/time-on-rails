class Work < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :date, presence: true

  def start
    return if started_at

    self.started_at = DateTime.current
  end

  def stop
    self.duration = duration + seconds_since_started
    self.started_at = nil
  end

  def seconds_since_started
    return 0 unless started_at?

    (DateTime.current.to_time - started_at).to_i
  end

  def time_description
    full_time = duration + seconds_since_started

    hours = full_time / 3600
    minutes = (full_time  - hours * 3600) / 60
    seconds = (full_time - hours * 3600 - minutes * 60) % 60

    [
      ("#{hours} hours" if hours.positive?),
      ("#{minutes} minutes" if minutes.positive?),
      ("#{seconds} seconds" if seconds.positive?)
    ].compact.join(" ")
  end
end
