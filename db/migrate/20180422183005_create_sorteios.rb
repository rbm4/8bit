class CreateSorteios < ActiveRecord::Migration[5.2]
  def change
    create_table :sorteios do |t|

      t.timestamps
    end
  end
end
