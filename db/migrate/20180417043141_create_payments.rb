class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.string :amount_tck
      t.string :currency
      t.string :status
      t.string :address_payment
      t.string :address_receive

      t.timestamps
    end
  end
end
