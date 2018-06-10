class UserBookPair
  attr_reader :num_of_users, :num_of_books, :num_of_evaluation, :data, :similarity_score, :not_evaluated_books, :output_flag
  attr_writer :num_of_users, :num_of_books, :num_of_evaluation, :data, :similarity_score, :not_evaluated_books, :output_flag

  def initialize(users, books, evaluation)
    @num_of_users        = users
    @num_of_books        = books
    @num_of_evaluation   = evaluation
    @data                = Array.new(@num_of_users).map { Array.new(@num_of_books) }
    @similarity_score    = {}
    @not_evaluated_books = []
    @output_flag         = 0
  end

  def gets_data
    if @num_of_evaluation.nil?
      @num_of_users.times do |i|
        @data[i] = STDIN.gets.split(' ').map(&:to_f)
      end

      @output_flag = 1
    else
      @num_of_evaluation.times do |_|
        input_value = STDIN.gets.split(' ').map(&:to_f)

        user_index = input_value[0].to_i
        book_id    = input_value[1].to_i
        evaluation = input_value[2]

        @data[user_index - 1][book_id - 1] = evaluation
      end

      @data.each do |v|
        v.map! { |s| s || -1.0 } # beautiful!
      end
    end
  end

  def get_similarity_score(user)
    # calculate similarity score
    @data.each_with_index do |v, i|
      sum = 0
      v.each_with_index do |w, j|
        break if i == user - 1

        # In the case of a negative value, it means that it's not evaluated.
        next if @data[user - 1][j] == -1 || w == -1

        sum += (@data[user - 1][j] - w).abs**2
      end

      # make result
      @similarity_score[i + 1] = 1.0 / (Math.sqrt(sum) + 1) unless i == user - 1
    end

    result = @similarity_score

    # initialize similarity_score
    @similarity_score = {}

    result
  end

  def recommend_item(user, book=nil)
    sum_of_books_score      = []
    sum_of_similarity_score = []
    user_list               = @data.drop(1)
    result                  = []
    similarity_score        = get_similarity_score(user)

    # extract not evaluated list
    @data[user - 1].each_with_index do |x, k|
      @not_evaluated_books << k + 1 if x == -1
    end

    @not_evaluated_books.each do |v|
      s = 0
      a = 0

      user_list.each_with_index do |w, i|
        next if w[v - 1] == -1

        s += w[v - 1] * similarity_score[i + 2]
        a += similarity_score[i + 2]
      end

      sum_of_books_score << [v, s]
      sum_of_similarity_score << [v, a]
    end

    # initialize
    @not_evaluated_books = []

    sum_of_books_score.each_with_index do |v, i|
      # p "v: #{v[1]}"
      # p "sum_of_similarity_score: #{sum_of_similarity_score[i][1]}"

      # [TODO] In v == 5, rounding error occurs. My answer is 1.42841741639338, but correct answer is 1.4284174163933803.
      # 恐らく、小数第１７以下を四捨五入して、小数点以下を１６桁にすれば正しくなりそう
      result << [v[0], v[1] / sum_of_similarity_score[i][1]]
    end

    # sort in descending order
    result.sort_by! { |_, score| score }.reverse!

    if book.nil?
      result
    else
      result[book - 1]
    end
  end

  def validator(user, book, evaluation)
    # user check
    return false, 'user not found.' if (user =~ /^\d+$/).nil?

    user = user&.to_i
    return false, 'user not found.' if user > @num_of_users || user < 1

    # book check
    unless book.nil?
      return false, 'no appropriate item' if (book =~ /^\d+$/).nil?

      book = book&.to_i
      return false, 'no appropriate item' if book > @num_of_books || book < 1
    end

    # evaluation check
    unless evaluation.nil?
      return false, 'can not evaluate.' if (evaluation =~ /^\d+\.\d+$/).nil?

      evaluation = evaluation&.to_f
      return false, 'can not evaluate.' if evaluation > 5.0 || evaluation < 0.0
    end
  end
end
