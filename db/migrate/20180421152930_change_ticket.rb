class ChangeTicket < ActiveRecord::Migration[5.2]
  def change
    remove_column :tickets, :valid
    add_column :tickets, :active, :boolean
  end
end
