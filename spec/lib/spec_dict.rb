require 'dict'
require 'spec_helper'

class TestDictMaker

	describe Maker do

		before do
			@m = Maker.new
			@f = @m.find_all_texts
			@l = @m.read_each_file(['pg84.txt'])
		end

		it "should read each file in the directory /data" do
			@f.length.should eq(3)
		end

		it "should read each file line by line" do
			@l = @m.read_each_file(@f)
			@l.length.should eq(24791)
		end

		it "should append each file to the all_lines"	do
			@l.length.should eq(6428)
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
			@m.write_to_file(@l)
			f = @m.find_all_texts('./output/')
			f[0].should eq('resultant.txt')
		end

		it "should create a word hash, including only new words" do
			@m.all_words.should be_true
		end
	end


end 