class ChangePremiados < ActiveRecord::Migration[5.2]
  def change
      add_column :premiados, :premio_entregue, :boolean
      add_column :tickets, :position, :string
  end
end
