class PageView < ApplicationRecord
  belongs_to :user

  validates :path, presence: true

  scope :on_date, ->(date) { where(created_at: date.all_day) }
  scope :in_range, ->(start_date, end_date) { where(created_at: start_date.beginning_of_day..end_date.end_of_day) }
end
