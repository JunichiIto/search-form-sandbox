class Project < ApplicationRecord
  belongs_to :customer
  has_many :memberships
  has_many :members, through: :memberships

  validates :name, presence: true
end
