def sigma(hash, data)
  sum = 0.0
  data.link.each do |e|
    # next if hash[e].num_link == 0
    sum += hash[e].score / hash[e].num_link
  end
  sum
end

file_list = Dir.entries('source')
file_list.shift(2)

Html        = Struct.new(:score, :num_link, :link)
struct_hash = {}

# make struct hash
file_list.each do |e|
  struct_hash[e] = Html.new(1.0, 0, [])
end

# read files and make struct
struct_hash.each_key do |key|
  File.open('./source/' + key, 'r') do |f|
    # detect string includes .html
    link_list = f.read.split(' ').select { |e| e.match(/.*\.html/) }

    # Be careful in the direction of the link
    link_list.each do |e|
      struct_hash[e].link << key
    end

    # num_link is the number of links written in file
    struct_hash[key].num_link = link_list.size
  end
end

k = 20

k.times do |i|
  next_score = {}

  # calculate score
  struct_hash.each do |key, value|
    next_score[key] = 0.15 + 0.85 * sigma(struct_hash, value)
  end

  # update score
  next_score.each do |key, value|
    struct_hash[key].score = value
  end
end

tmp    = []
result = {}

# extract top score
struct_hash.each do |key, value|
  tmp << value.score
end
top_score = tmp.sort.reverse[0]

# calculate result
struct_hash.each do |key, value|
  result[key] = (value.score / top_score).round(2)
end

result = result.sort_by { |_, value| -value }

# output result
result.each do |e|
  puts sprintf("%.2f %s", e[1], e[0])
end
