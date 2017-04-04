class ShiftAllRoles < ActiveRecord::Migration[5.0]
  def change
    execute(<<-SQL)
      update users set role = 2 where role = 1;
    SQL
    execute(<<-SQL)
      update users set role = 1 where role = 0;
    SQL
  end
end
