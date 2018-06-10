class FriendsAdjacencyList
  attr_reader :num_of_users, :num_of_friends, :friends_list
  attr_writer :num_of_users, :num_of_friends, :friends_list

  def initialize(user, friend)
    @num_of_users   = user
    @num_of_friends = friend
    @friends_list   = []

    user.times do
      @friends_list << []
    end
  end

  def gets_data
    @num_of_friends.times do |_|
      friend1, friend2 = STDIN.gets.split(' ')

      # make adjacency list
      @friends_list[friend1&.to_i - 1] << friend2&.to_i - 1
      @friends_list[friend2&.to_i - 1] << friend1&.to_i - 1
    end
  end

  def convert_list
    # make full adjacency list
    @friends_list.each_with_index do |parent, parent_index|
      parent.each do |child|
        # detect elements except parent
        data = @friends_list[child].select { |e| e != parent_index && !parent.include?(e)}

        # update parent
        parent += data
        @friends_list[parent_index] = parent
        @friends_list[parent_index].uniq!

        # recursive call
        convert_list unless data.empty?
      end
    end
  end

  def answer_question
    num_of_question = STDIN.gets

    num_of_question&.to_i.times do
      friend1, friend2 = STDIN.gets.split(' ')

      if @friends_list[friend1&.to_i - 1].include?(friend2&.to_i - 1)
        puts 'yes'
      else
        puts 'no'
      end
    end
  end
end
