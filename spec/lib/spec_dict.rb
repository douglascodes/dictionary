require 'dict'
require 'spec_helper'

class TestDictMaker

	describe Maker do

		before do
			@m = Maker.new
			@m.in_dir = './seed/'
			@f = @m.find_all_texts()
			@l = @m.read_each_file(@f)
			@words = @m.split_lines(@l)
			@w = @m.hash_words(@words)
		end

		it "should read each file in the directory ./seed/" do
			@f.length.should eq(9)
		end

		it "should read each file line by line" do
			@l = @m.read_each_file(@f)
			@l.length.should be > 1000
		end

		it "should append each file to the all_lines"	do
			@l.length.should be > 2000
		end

		it "should ignore Gutenberg text lines" do
			@l.each { |r|
				r.include?('Gutenberg').should be_false
			}
			@l << "Gutenberg\n"
			test_gute = false
			@l.each { |r|
				if r.include?('Gutenberg') then test_gute = true end

			}
			test_gute.should be_true
		end
	
		it "should strip all non alpha chars from lines" do
			@l.each { |r|
				r.include?('.').should be_false
				r.include?('1').should be_false
				r.include?('  ').should be_false
			}
		end

		it "should only keep useful lines" do
			@m.keep_line?('  ').should be_false
			@m.keep_line?('BEST').should be_true
			@m.keep_line?('SDFGHJK SDFKJ').should be_false
			@m.keep_line?('RETURN TO BASIC').should be_true
		end

		it "should normalize a line of text to just Alphas" do
			line = "Butter, bread is! better()"
			@m.normalize(line)
			line.should eq('Butter bread is better')
		end

		it "should write to the resultant.txt file" do
			@m.write_to_file(@w)
			f = @m.find_all_texts('./output/')
			f[0].should eq('resultant.txt')
		end

		it "should check the word hash" do
			@w.key?('THE').should be_true
			@m.dict.should be_true
			@m.dict.key?('IS').should be_true
		end

		it "should detect words with letters repeated three times" do
			@m.count_for_triples('Abracadabra').should be_false
			@m.count_for_triples('XXIII').should be_true
		end
	end


end 