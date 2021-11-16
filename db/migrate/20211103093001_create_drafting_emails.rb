class CreateDraftingEmails < ActiveRecord::Migration[6.1]
  def change
    create_table :drafting_emails, id: false do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :email, foreign_key: true
      
      t.timestamps
    end
  end
end
