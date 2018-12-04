module ApplicationHelper
  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'avatar.jpg'
    end
  end

  def correct_declension(number, declensions)
    return declensions[:third_declension] if (number % 100).between?(11, 14)

    remainder = number % 10

    case remainder
    when 1
      declensions[:first_declension]
    when 2..4
      declensions[:second_declension]
    else
      declensions[:third_declension]
    end
  end
end
