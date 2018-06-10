def validator(user_book_pair, user, book, evaluation)
  # user check
  return false, 'user not found.' if (user =~ /^\d+$/).nil?

  user = user&.to_i
  return false, 'user not found.' if user > user_book_pair.num_of_users || user < 1

  # book check
  unless book.nil?
    return false, 'no appropriate item' if (book =~ /^\d+$/).nil?

    book = book&.to_i
    return false, 'no appropriate item' if book > user_book_pair.num_of_books || book < 1
  end

  # evaluation check
  unless evaluation.nil?
    return false, 'can not evaluate.' if (evaluation =~ /^\d+\.\d+$/).nil?

    evaluation = evaluation&.to_f
    return false, 'can not evaluate.' if evaluation > 5.0 || evaluation < 0.0
  end
end
