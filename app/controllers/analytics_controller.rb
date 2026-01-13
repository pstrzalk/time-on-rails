class AnalyticsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Default to last 365 days
    @end_date = Date.current
    @start_date = @end_date - 364.days

    # Get daily view counts for the heatmap
    @daily_views = current_user.page_views
                               .in_range(@start_date, @end_date)
                               .group("DATE(created_at)")
                               .count

    # Calculate statistics
    @total_views = @daily_views.values.sum
    @days_active = @daily_views.keys.count
    @max_views_per_day = @daily_views.values.max || 0

    # Most visited pages
    @top_pages = current_user.page_views
                             .in_range(@start_date, @end_date)
                             .group(:path)
                             .count
                             .sort_by { |_, count| -count }
                             .first(5)
  end
end
