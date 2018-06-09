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

