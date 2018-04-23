class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    add_column :premiados, :currency, :string
    create_table :emails do |t|
      t.string :email
      t.timestamps
    end
  end
end
