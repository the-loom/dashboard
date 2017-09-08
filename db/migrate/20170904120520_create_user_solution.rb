class CreateUserSolution < ActiveRecord::Migration[5.0]
  def change
    create_table :user_solutions do |t|
      t.integer :user_id
      t.integer :solution_id
    end

    execute <<-SQL
    insert into user_solutions(user_id, solution_id)
    select user_id, id
    from solutions
    SQL

    remove_column :solutions, :user_id
  end
end
