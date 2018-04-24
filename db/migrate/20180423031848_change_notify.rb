class ChangeNotify < ActiveRecord::Migration[5.2]
  def change
    rename_table :notify_emails, :delivers
  end
end
