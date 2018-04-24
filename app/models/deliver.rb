class Deliver < ApplicationRecord
    validates :email, uniqueness: true
end
