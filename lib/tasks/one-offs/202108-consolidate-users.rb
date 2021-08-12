ActiveRecord::Base.transaction do
  user_ids_to_join = [397, 1322]
  user_id_to_keep = user_ids_to_join.first
  user_ids_to_remove = user_ids_to_join - [user_id_to_keep]

  # identities
  Identity.where(user_id: user_ids_to_remove).update_all(user_id: user_id_to_keep)

  # memberships
  Membership.where(user_id: user_ids_to_remove).update_all(user_id: user_id_to_keep)

  # remove user
  User.where(id: user_ids_to_remove).destroy_all
end
