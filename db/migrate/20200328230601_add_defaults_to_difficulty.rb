class AddDefaultsToDifficulty < ActiveRecord::Migration[5.2]
  def change
    change_column_default :exercises, :difficulty, 1
    change_column_default :peer_review_challenges, :difficulty, 1

    execute 'update exercises set difficulty = 1 where difficulty is null'
    execute 'update peer_review_challenges set difficulty = 1 where difficulty is null'
  end
end
