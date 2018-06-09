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
