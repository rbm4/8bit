class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.string :wallet
      t.string :size
      t.boolean :valid
      t.string :currency

      t.timestamps
    end
  end
end
