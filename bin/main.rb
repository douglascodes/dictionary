require './lib/dict'

m = Maker.new
f = m.find_all_texts
l = m.read_each_file(f)
w = m.split_lines(l)
m.hash_words(w)
m.write_to_file(m.dict)