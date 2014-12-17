class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :source_url
      t.text :content
      t.text :metadata

      t.timestamps
    end
  end
end
