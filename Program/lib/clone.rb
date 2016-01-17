require_relative './glob'

class Clone
	def initialize(repo_links, counter, lines_num, words_num, count, hash)
		@repo_links = repo_links
		@counter = counter
		@lines_num = lines_num
		@words_num = words_num
		@count = count
		@hash = hash

		@repositories_to_csv = []
		@cloning_folder = 'test'
		@go_back = '..'

		@change_names = 0.to_i
	end

	def run
		Dir.chdir(@cloning_folder)

		@repo_links.each do |link|
			`mkdir #{@change_names}`
			Dir.chdir("./#{@change_names}/")
			`git clone #{link}`

			repo_name = link.split('/').last
			repo_name = repo_name.split('.').first
			repo_name = repo_name.chomp()

			Dir.chdir(repo_name)

			globbing = Glob.new(@counter, @lines_num, @words_num, @count, @hash)
			@lines_num, @words_num, @count, @hash = globbing.glob_it()

			link = link.chomp()
			@repositories_to_csv << "#{link},#{@lines_num}\n"

			Dir.chdir(@go_back)
			Dir.chdir(@go_back)
			@change_names += 1
			@lines_num = 0.to_i
		end
		return @repositories_to_csv, @count, @words_num, @hash
	end
end