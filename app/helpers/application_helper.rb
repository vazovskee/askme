module ApplicationHelper
  QUESTION_DECLENSION = { first_declension: 'вопрос',
                          second_declension: 'вопроса',
                          third_declension: 'вопросов' }.freeze
  ASKING_DECLENSION = { first_declension: 'был задан',
                        second_declension: 'было задано',
                        third_declension: 'было задано' }.freeze

  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'avatar.jpg'
    end
  end

  def questions_amount(questions)
    if questions.present?
      question_number = questions.length
      'Пользователю ' \
      "#{correct_declension(question_number, ASKING_DECLENSION)} " \
      "#{question_number} " \
      "#{correct_declension(question_number, QUESTION_DECLENSION)}"
    else
      'Ни одного вопроса не задано. Задайте его первым!'
    end
  end

  private

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
