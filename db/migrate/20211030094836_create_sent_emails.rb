class CreateSentEmails < ActiveRecord::Migration[6.1]
  def change
    create_table :sent_emails, id: false do |t|
      t.boolean :is_starred, default: false
      t.boolean :is_deleted, default: false

      t.timestamps
    end
    add_reference :sent_emails, :user, foreign_key: true
    add_reference :sent_emails, :email, foreign_key: true
  end
end
