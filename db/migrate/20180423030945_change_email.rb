class ChangeEmail < ActiveRecord::Migration[5.2]
  def change
    rename_table :emails, :notify_emails
  end
end
