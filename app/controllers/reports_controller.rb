class ReportsController < ApplicationController
  def index
    @month = params[:month].presence || DateTime.current.month
    @year = params[:year] || DateTime.current.year

    start_date = Date.parse("01/#{@month}/#{@year}")
    end_date = start_date.at_end_of_month

    @reports = Work.where(user: current_user)
                   .where(date: [ start_date..end_date ])
                   .select("works.*, SUM(duration) as total_duration")
                   .group(:project_id)
  end
end
