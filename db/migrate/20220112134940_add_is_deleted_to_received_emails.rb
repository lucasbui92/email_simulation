class AddIsDeletedToReceivedEmails < ActiveRecord::Migration[6.1]
  def change
    add_column :received_emails, :is_deleted, :boolean, default: false
  end
end
