class Project < ApplicationRecord
  belongs_to :user
  has_many :works, dependent: :destroy

  validates :name, presence: true
end
