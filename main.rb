require_relative 'lib/user_book_pair'
require_relative 'lib/detect_similar_users'
require_relative 'lib/recommend_item'
require_relative 'lib/validator'

# gets number of user and books
user, book, evaluation = STDIN.gets.split(' ')
user_book_pair = UserBookPair.new(user.to_i, book.to_i, evaluation&.to_i)

gets_data(user_book_pair)

loop do
  print '> '
  command, user, book, evaluation = STDIN.gets.split(' ')

  # exit
  break if command == 'exit' || command == 'quit'

  # next if user.nil? || command != 'rec' || command != 'eval'
  next if user.nil?

  # validation
  check, message = validator(user_book_pair, user, book, evaluation)
  user       = user&.to_i
  book       = book&.to_i
  evaluation = evaluation&.to_f

  unless check || check.nil?
    puts message
    next
  end

  if command == 'rec'
    if book.nil?
      result = recommend_item(user_book_pair, user)

      # output result
      result.each do |v|
        puts v.join(' ')
      end
    else
      result = recommend_item(user_book_pair, user, book)
      if result.nil?
        puts 'no appropriate item'
      else
        puts result.join(' ')
      end
    end
  elsif command == 'eval'
    user_book_pair.data[user - 1][book - 1] = evaluation
    puts user_book_pair.data[user - 1][book - 1]
    puts 'evaluation is complete.'
  end
end