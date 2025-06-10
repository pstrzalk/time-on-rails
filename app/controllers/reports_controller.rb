class ReportsController < ApplicationController
  def index
    @month = (params[:month].presence || DateTime.current.month).to_i
    @year = (params[:year].presence || DateTime.current.year).to_i

    start_date = Date.new(@year, @month, 1)
    end_date = start_date.at_end_of_month

    @reports = Work.where(user: current_user)
                   .where(date: [ start_date..end_date ])
                   .select("works.*, SUM(duration) as total_duration")
                   .group(:project_id)
  end
end
