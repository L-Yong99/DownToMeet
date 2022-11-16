class ChangeCommentFromAttendances < ActiveRecord::Migration[7.0]
  def change
    change_column :attendances, :comment, :string, null: true
  end
end
