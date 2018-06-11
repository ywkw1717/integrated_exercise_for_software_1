require_relative 'lib/user_book_pair'

# gets number of user and books
user, book, evaluation = STDIN.gets.split(' ')
user_book_pair = UserBookPair.new(user.to_i, book.to_i, evaluation&.to_i)

user_book_pair.gets_data

loop do
  begin
    command, user, book, evaluation = STDIN.gets.split(' ')
  rescue
    # no interface case
    result = user_book_pair.get_similarity_score(1) # user1
    result = result.sort_by { |_, value| -value }
    result.each do |e|
      puts e.join(' ')
    end

    result = user_book_pair.recommend_item(1)
    result.each do |e|
      puts e.join(' ')
    end
    break
  end
  print '> '

  # exit
  break if command == 'exit' || command == 'quit'

  # next if user.nil? || command != 'rec' || command != 'eval'
  next if user.nil?

  # validation
  check, message = user_book_pair.validator(user, book, evaluation)
  user       = user&.to_i
  book       = book&.to_i
  evaluation = evaluation&.to_f

  unless check || check.nil?
    puts message
    next
  end

  if command == 'rec'
    if book.nil?
      result = user_book_pair.recommend_item(user)

      # output result
      result.each do |v|
        puts v.join(' ')
      end
    else
      result = user_book_pair.recommend_item(user, book)
      if result.nil?
        puts 'no appropriate item'
      else
        puts result.join(' ')
      end
    end
  elsif command == 'eval'
    if evaluation.nil?
      puts 'can not evaluate.'
      next
    end

    user_book_pair.data[user - 1][book - 1] = evaluation
    puts user_book_pair.data[user - 1][book - 1]
    puts 'evaluation is complete.'
  end
end
