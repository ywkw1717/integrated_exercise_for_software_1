require_relative 'lib/user_book_pair'
require_relative 'lib/friends_adjacency_list'

# gets user_book_pair
user, book, evaluation = STDIN.gets.split(' ')
user_book_pair = UserBookPair.new(user.to_i, book.to_i, evaluation&.to_i)
user_book_pair.gets_data

# gets friends_adjacency_list
friend = STDIN.gets
friends_adjacency_list = FriendsAdjacencyList.new(user.to_i, friend&.to_i)
friends_adjacency_list.gets_data
friends_adjacency_list.convert_list

result = user_book_pair.recommend_item(1, nil, friends_adjacency_list.friends_list[0])

result.each do |e|
  puts e.join(' ')
end
