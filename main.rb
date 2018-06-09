require_relative 'lib/user_book_pair'
require_relative 'lib/detect_similar_users'
require_relative 'lib/recommend_item'

# gets number of user and books
user, book = STDIN.gets.split(' ')
user_book_pair = UserBookPair.new(user.to_i, book.to_i)

detect_similar_users(user_book_pair)
recommend_item(user_book_pair)
