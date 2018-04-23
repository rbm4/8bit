class Email < ApplicationRecord
    validates :email, uniqueness: true
end
