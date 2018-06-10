def gets_data(user_book_pair)
  if user_book_pair.num_of_evaluation.nil?
    user_book_pair.num_of_users.times do |i|
      user_book_pair.data[i] = STDIN.gets.split(' ').map(&:to_f)
    end

    user_book_pair.output_flag = 1
  else
    user_book_pair.num_of_evaluation.times do |_|
      input_value = STDIN.gets.split(' ').map(&:to_f)

      user_index = input_value[0].to_i
      book_id    = input_value[1].to_i
      evaluation = input_value[2]

      user_book_pair.data[user_index - 1][book_id - 1] = evaluation
    end

    user_book_pair.data.each do |v|
      v.map! { |s| s || -1.0 } # beautiful!
    end
  end
end

def get_similarity_score(user_book_pair, user)
  # calculate similarity score
  user_book_pair.data.each_with_index do |v, i|
    sum = 0
    v.each_with_index do |w, j|
      break if i == user - 1

      # In the case of a negative value, it means that it's not evaluated.
      next if user_book_pair.data[user - 1][j] == -1 || w == -1

      sum += (user_book_pair.data[user - 1][j] - w).abs**2
    end

    # make result
    user_book_pair.similarity_score[i + 1] = 1.0 / (Math.sqrt(sum) + 1) unless i == user - 1
  end

  result = user_book_pair.similarity_score

  # initialize similarity_score
  user_book_pair.similarity_score = {}

  result
end
