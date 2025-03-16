class Work < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :date, presence: true

  def in_progress?
    started_at.present?
  end

  def start
    return if started_at

    self.started_at = DateTime.current
  end

  def stop
    self.duration = total_time
    self.started_at = nil
  end

  def seconds_since_started
    return 0 unless started_at?

    (DateTime.current.to_time - started_at).to_i
  end

  def time_description
    hours = total_time / 3600
    minutes = (total_time  - hours * 3600) / 60
    seconds = (total_time - hours * 3600 - minutes * 60) % 60

    [
      ("#{hours} hours" if hours.positive?),
      ("#{minutes} minutes" if minutes.positive?),
      ("#{seconds} seconds" if seconds.positive?)
    ].compact.join(" ")
  end

  def total_time
    duration.to_i + seconds_since_started
  end
end
