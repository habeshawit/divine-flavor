class CreateSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :steps do |t|
      t.text :instructions
      t.belongs_to :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
