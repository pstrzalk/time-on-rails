class ReportsController < ApplicationController
  def index
    @month = params[:month].presence || DateTime.current.month
    @year = params[:year] || DateTime.current.year

    start_date = Date.parse("01/#{@month}/#{@year}")
    end_date = start_date.at_end_of_month

    @reports = Work.select("works.*, SUM(duration) as total_duration").where(date: [ start_date..end_date ]).group(:project_id)
  end
end
