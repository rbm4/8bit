class Deliver < ApplicationRecord
    validates :email, uniqueness: true
    validates :email, presence: true, 'valid_email_2/email': true
end
