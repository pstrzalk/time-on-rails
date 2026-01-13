module AnalyticsHelper
  def heatmap_intensity(count, max_count)
    return "bg-gray-800" if count.nil? || count == 0
    return "bg-gray-800" if max_count == 0

    percentage = (count.to_f / max_count * 100).round

    case percentage
    when 0 then "bg-gray-800"
    when 1..25 then "bg-orange-900"
    when 26..50 then "bg-orange-700"
    when 51..75 then "bg-orange-500"
    else "bg-orange-400"
    end
  end

  def month_label_for_week(date)
    # Return month name if this is the first week of a month
    date.day <= 7 ? date.strftime("%b") : nil
  end
end
