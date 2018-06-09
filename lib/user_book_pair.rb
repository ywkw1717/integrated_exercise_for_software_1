class UserBookPair
  attr_reader :num_of_users, :num_of_books, :num_of_evaluation, :data, :similarity_score, :not_evaluated_books
  attr_writer :num_of_users, :num_of_books, :num_of_evaluation, :data, :similarity_score, :not_evaluated_books

  def initialize(users, books, evaluation)
    @num_of_users        = users
    @num_of_books        = books
    @num_of_evaluation   = evaluation
    @data                = Array.new(@num_of_users).map { Array.new(@num_of_books) }
    @similarity_score    = {}
    @not_evaluated_books = []
  end
end

