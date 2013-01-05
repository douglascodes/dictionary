#read each file in the data directory and write a new file to
#the results directory
class Maker
	attr_accessor :out_file, :in_dir, :dict, :all_lines, :all_words, :vowels

	def initialize(dir='./data/', out='./output/resultant.txt')
		@in_dir = dir
		@out_file = out
		@dict = Hash.new
		@vowels = 'AEIOUY'
		@all_chars = [*('A'..'Z')] << '-' << '\''
		@all_words = []
		start_with_known()
	end

	def consume_words

	end

	def read_all_lines(text, lines)
		# text_body = false
		# The commented lines are for limiting the ingested text
		# I do not think it is relevant anymore to do that. Left in for
		# understanding
		text.each { |line|
			line.upcase!
				# if text_body
				# 	if detect_end_of_gute(line)
				# 		break
				# 	end
					if keep_line?(line) then lines << normalize(line) end
				# else
				# 	if detect_start_of_gute(line)
				# 		text_body = true
				# 	end
				# end
			}
		return lines
	end

	def start_with_known
		return unless File.exist?("./output/resultant.txt")
		w = IO.readlines("./output/resultant.txt")
		w.each { |c| c.chomp! }
		hash_words(w)
	end

	def normalize(line)
	#removes special chars and makes the line just words
		line.gsub!(/[^[:alpha:]']/, ' ')
		line.squeeze!(' ')
		line.strip!
		return line
	end

	def keep_line?(line)
		if line.length < 2 then return false end
		if line.count(@vowels) == 0 then return false end
		return true
	end
	
	def keep_word?(word)
		return false if word.count(@vowels) < 1
		return false if word[0] == "'"
		return false if word.count("'") > 1
		return false if word[-1] == "'"
		return false if count_for_triples(word)
		return true
	end

	def count_for_triples(word)
		a = b = c = nil
		word.each_char { |ch| 
			if not @all_chars.include? ch then return true end
				# also checks to see if the character is of the allowed kind
			c = b
			b = a 
			return true if ch == b && b == c && nil != c
			a = ch
		}
		return false
	end

	def read_each_file(files)
		lines = []
		if not files[0] then return end
		f = files[0]
			full_text = IO.readlines((@in_dir + f))
			lines = read_all_lines(full_text, lines)
			File.delete((@in_dir + f))	
		return lines
	end

	def find_all_texts(dir=@in_dir)
		files = Dir.entries(dir)
		files.delete_if { |f| 
			f == '.' || f == '..'
		}
		return files
	end

	def write_to_file(data, file=@out_file)
		File.open(file, 'w') { |f| 
			data.each_key { |h|
				f.write((h + "\n"))
			}
		}
	end

	def split_lines(lines = @all_lines)
		if not lines then return end
		lines.each { |l|
			line_w = l.split
			@all_words.concat(line_w)
		}
		return @all_words
	end

	def hash_words(words=@all_words)
		new_words = 0
		if words
			words.each { |w|
				if @dict.key?(w) then next end
					if keep_word?(w)
					@dict.merge!(w => w.length)
					new_words += 1
					end
			}
		end
		puts new_words.to_s
		return @dict
	end

	def consume_words

	end

end