class Membership < ApplicationRecord
  belongs_to :project
  belongs_to :member
end
