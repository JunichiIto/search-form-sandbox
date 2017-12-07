class Member < ApplicationRecord
  has_many :memberships
  has_many :projects, through: :memberships

  validates :name, presence: true
end
