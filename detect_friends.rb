require_relative './lib/friends_adjacency_list'

user, friend = STDIN.gets.split(' ')
friends_adjacency_list = FriendsAdjacencyList.new(user&.to_i, friend&.to_i)

friends_adjacency_list.gets_data
friends_adjacency_list.convert_list
friends_adjacency_list.answer_question
