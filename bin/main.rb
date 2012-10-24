require './lib/dict'

m = Maker.new
f = m.find_all_texts
l = m.read_each_file(['pg84.txt'])

puts l[-10..-1]