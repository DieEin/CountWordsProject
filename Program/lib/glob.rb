class Glob
	def initialize(counter, lines_num, words_num, count, hash)
		@counter = counter
		@lines_num = lines_num
		@words_num = words_num
		@count = count
		@hash = hash

		@expected_extentions = ['.rb', ['.cc', '.cpp', '.h', '.hh'], '.java']
		@everything = '*'
		@go_back = '..'
	end

	def parse(string)
		@count += string.scan(/[[:punct:]]/).count
		words = string.downcase.scan(/\w+/)

		words.each do |word|
			@hash[word] += 1
			@words_num += 1
		end
	end
	def parse_file(filename)
		result = File.open(filename, 'r')
		result = result.read

		parse(result)
	end
	
	def glob_it
		Dir.glob(@everything).each do |filename|
			if File.file?(filename)
				if @expected_extentions[@counter].include? File.extname(filename)
					@lines_num += `wc -l "#{filename}"`.strip.split(' ')[0].to_i
					parse_file(filename)
				end
			elsif File.directory?(filename)
				Dir.chdir(filename)
				glob_it()
				Dir.chdir('..')
			end
		end

		return @lines_num, @words_num, @count, @hash
	end
end