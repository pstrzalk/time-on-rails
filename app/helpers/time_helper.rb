module TimeHelper
  def time_description(time)
    hours = time / 3600
    minutes = (time - hours * 3600) / 60
    seconds = (time - hours * 3600 - minutes * 60) % 60

    [
      ("#{hours} hours" if hours.positive?),
      ("#{minutes} minutes" if minutes.positive?),
      ("#{seconds} seconds" if seconds.positive?)
    ].compact.join(" ")
  end
end
