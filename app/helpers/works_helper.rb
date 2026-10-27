module WorksHelper
  include TimeHelper

  def work_day_label(date)
    if date == Date.current
      "Today"
    elsif date == Date.current.yesterday
      "Yesterday"
    else
      date.strftime("%A, %d-%m-%Y")
    end
  end

  def work_day_summary(sessions_count:, total_time:)
    "#{pluralize(sessions_count, 'session')} • #{time_description(total_time).presence || '0 seconds'}"
  end
end
