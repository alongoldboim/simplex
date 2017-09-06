class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :from
      t.string :to
      t.float :rate
      t.timestamps null: false
    end
  end
end
