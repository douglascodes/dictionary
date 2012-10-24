#read each file in the data directory and write a new file to
#the results directory
class Maker
	attr_accessor :out_file, :in_dir, :dict, :all_lines, :all_words, :vowels

	def initialize(dir='./data/', out='./output/resultant.txt')
		@in_dir = dir
		@out_file = out
		@dict = Array.new(20)
		@vowels = 'AEIOUY'
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

	def normalize(line)
	#removes special chars and makes the line just words
		line.gsub!(/[^[:alpha:]]/, ' ')
		line.squeeze!(' ')
		line.strip!
		return line
	end

	def keep_line?(line)
		if line.length < 2 then return false end
		if line.count(@vowels) == 0 then return false end
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
			data.each { |d|
				f.write((d.to_s + "\n"))

			}
		}
	end

	def split_lines(lines = @all_lines)
		words = Hash.new
		lines.each { |l|
			line_w = l.split
			hash_words(words, line_w)
		}
		return words
	end

	def hash_words(words, line)
		line.each { |w|
			words.merge!(w => w.length)
		}
		return words
	end

	def consume_words

	end

end