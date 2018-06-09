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
      # extract not evaluated list
      if i.zero?
        user_book_pair.data[i].each_with_index do |x, k|
          user_book_pair.not_evaluated_books << k + 1 if x == -1
        end

        break
      end

      # In the case of a negative value, it means that it's not evaluated.
      next if user_book_pair.data[0][j] == -1 || w == -1

      sum += (user_book_pair.data[0][j] - w).abs**2
    end

    # make result
    user_book_pair.similarity_score[i + 1] = 1.0 / (Math.sqrt(sum) + 1) unless i.zero?
  end

  # sort in descending order
  result = user_book_pair.similarity_score.sort_by { |_, score| -score }

  # output result
  result.each do |v|
    puts v.join(' ')
  end
end

def recommend_item(user_book_pair)
  sum_of_books_score      = []
  sum_of_similarity_score = []
  user_list               = user_book_pair.data.drop(1)
  result                  = []

  user_book_pair.not_evaluated_books.each do |v|
    s = 0
    a = 0

    user_list.each_with_index do |w, i|
      next if w[v - 1] == -1

      s += w[v - 1] * user_book_pair.similarity_score[i + 2]
      a += user_book_pair.similarity_score[i + 2]
    end

    sum_of_books_score << [v, s]
    sum_of_similarity_score << [v, a]
  end

  sum_of_books_score.each_with_index do |v, i|
    # p "v: #{v[1]}"
    # p "sum_of_similarity_score: #{sum_of_similarity_score[i][1]}"

    # [TODO] In v == 5, rounding error occurs. My answer is 1.42841741639338, but correct answer is 1.4284174163933803.
    # 恐らく、小数第１７以下を四捨五入して、小数点以下を１６桁にすれば正しくなりそう
    result << [v[0], v[1] / sum_of_similarity_score[i][1]]
  end

  result.sort_by! { |_, score| score }.reverse!

  result.each do |v|
    puts v.join(' ')
  end
end

def main
  # gets number of user and books
  user, book = STDIN.gets.split(' ')
  user_book_pair = UserBookPair.new(user.to_i, book.to_i)

  detect_similar_users(user_book_pair)
  recommend_item(user_book_pair)
end

main
