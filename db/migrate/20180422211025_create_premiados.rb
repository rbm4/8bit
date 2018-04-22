class CreatePremiados < ActiveRecord::Migration[5.2]
  def change
    create_table :premiados do |t|
      t.string :sorteio_id
      t.string :wallet
      t.string :qtd
      t.boolean :premio_entregue
      t.string :position

      t.timestamps
    end
  end
end
