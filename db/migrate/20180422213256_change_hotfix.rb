class ChangeHotfix < ActiveRecord::Migration[5.2]
  def change
    remove_column :tickets, :position
    add_column :premiados, :position, :string
  end
end
