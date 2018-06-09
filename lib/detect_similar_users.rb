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
