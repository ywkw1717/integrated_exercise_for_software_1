class UserBookPair
  attr_reader :num_of_users, :num_of_books, :data, :similarity_score, :not_evaluated_books
  attr_writer :num_of_users, :num_of_books, :data, :similarity_score, :not_evaluated_books

  def initialize(users, books)
    @num_of_users        = users
    @num_of_books        = books
    @data                = Array.new(@num_of_users, Array.new(@num_of_books))
    @similarity_score    = {}
    @not_evaluated_books = []
  end
end

def detect_similar_users(user_book_pair)
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
    user_book_pair.similarity_score[i + 1] = 1.0 / (Math.sqrt(sum) + 1) unless i.zero?
  end

  # sort in descending order
  user_book_pair.similarity_score = user_book_pair.similarity_score.sort_by { |_, score| -score }

  # output result
  user_book_pair.similarity_score.each do |v|
    puts v.join(' ')
  end
end

main
