class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.belongs_to :customer, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
