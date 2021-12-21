class CreateReceivedEmails < ActiveRecord::Migration[6.1]
  def change
    create_table :received_emails do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :email, foreign_key: true
      t.integer :recipient_type, default: 0
      t.integer :status, default: 0
      t.boolean :is_starred, default: false

      t.timestamps
    end
  end
end
