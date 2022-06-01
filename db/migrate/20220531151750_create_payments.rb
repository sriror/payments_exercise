class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.decimal :amount, default: 0, null: false, precision: 8, scale: 2
      t.references :loan, foreign_key: true

      t.timestamps
    end
  end
end
