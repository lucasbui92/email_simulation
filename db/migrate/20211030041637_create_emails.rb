class CreateEmails < ActiveRecord::Migration[6.1]
  def change
    create_table :emails do |t|
      t.text :subject, null: false
      t.text :content, null: false
      # t.belongs_to :parent_email_id, foreign_key: true, null: true
      t.boolean :is_deleted, default: false

      t.timestamps
    end
  end
end
