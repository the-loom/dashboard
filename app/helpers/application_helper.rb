module ApplicationHelper
  def user_avatar(user)
    if user.avatar.attached?
      user.avatar
    else
      user.image
    end
  end

  def yes_no(bool_value)
    bool_value ? 'Si' : 'No'
  end
end
