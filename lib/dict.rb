#read each file in the data directory and write a new file to
#the results directory
class Maker
	attr_accessor :out_file, :in_dir, :dict, :all_lines, :all_words, :vowels

	def initialize(dir='./data/', out='./output/resultant.txt')
		@in_dir = dir
		@out_file = out
		@dict = Hash.new
		@vowels = 'AEIOUY'
		@all_words = []
		start_with_known()
	end

	def consume_words

	end

	def read_all_lines(text, lines)
		text_body = false
		text.each { |line|
			line.upcase!
				if text_body
					if detect_end_of_gute(line)
						break
					end
					if keep_line?(line) then lines << normalize(line) end
				else
					if detect_start_of_gute(line)
						text_body = true
					end
				end
			}
		return lines
	end

	def start_with_known
		w = IO.readlines("./output/resultant.txt")
		w.each { |c| c.chomp! }
		w.delete_if{ |bad|
			keep_word?(bad) == false
		}
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
		if word.count(@vowels) < 1 then return false end
		if word.count("'") > 1 then return false end

			return true
	end

	def read_each_file(files)
		lines = []
		files.each { |f|
			full_text = IO.readlines((@in_dir + f))
			lines = read_all_lines(full_text, lines)	
		}
		return lines
	end

	def detect_start_of_gute(line)
		if line.start_with?('*** START OF THIS PROJECT'.upcase) then return true end
		return false
	end

	def detect_end_of_gute(line)
	if line.start_with?('End of the Project'.upcase) then return true end
		return false
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
			data.each { |h, k|
				f.write((h + "\n"))
			}
		}
	end

	def split_lines(lines = @all_lines)
		lines.each { |l|
			line_w = l.split
			@all_words.concat(line_w)
		}
		return @all_words
	end

	def hash_words(words=@all_words)
		new_words = 0
		words.each { |w|
			if keep_word?(w)
				if @dict.key?(w) then next end
				@dict.merge!(w => w.length)
				new_words += 1
			end
		}
		puts new_words.to_s
		return @dict
	end

	def consume_words

	end

end