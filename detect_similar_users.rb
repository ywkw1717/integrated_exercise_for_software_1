class UserBookPair
  attr_reader :num_of_users, :num_of_books, :data, :similarity_score
  attr_writer :num_of_users, :num_of_books, :data, :similarity_score

  def initialize(users, books)
    @num_of_users     = users
    @num_of_books     = books
    @data             = Array.new(@num_of_users, Array.new(@num_of_books))
    @similarity_score = Array.new(@num_of_users - 1)
  end
end

def main
  # gets number of user and books
  user, book = STDIN.gets.split(' ')
  user_book_pair = UserBookPair.new(user.to_i, book.to_i)

  # gets data
  user_book_pair.num_of_users.times do |i|
    user_book_pair.data[i] = STDIN.gets.split(' ').map(&:to_f)
  end

  # calculate similarity score
  user_book_pair.data.each_with_index do |v, i|
    sum = 0
    v.each_with_index do |w, j|
      break if i.zero?

      # In the case of a negative value, it means that it's not evaluated.
      next if user_book_pair.data[0][j] == -1 || w == -1

      sum += (user_book_pair.data[0][j] - w).abs**2
    end

    # make result
    user_book_pair.similarity_score[i - 1] = [i + 1, 1.0 / (Math.sqrt(sum) + 1)]
  end

  # sort in descending order
  user_book_pair.similarity_score.sort_by! { |_, score| score }.reverse!

  # output result
  user_book_pair.similarity_score.each do |v|
    puts v.join(' ')
  end
end

main
