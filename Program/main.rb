require './lib/clone'
require './lib/result'

class Main
	def initialize(used_hash)
		@hash = used_hash

		@words_num = 0.to_i
		@lines_num = 0.to_i
		@counter = 0.to_i
		@count = 0.to_i
		@repo_links = []
		@repositories_to_csv = []

		@repositories = ['Ruby_Repositories', 'CC_Repositories', 'Java_Repositories']
		@text_files = ['ruby_repos.txt', 'cc_repos.txt', 'java_repos.txt']
		@file_names = ['ruby_repos', 'cc_repos', 'java_repos']
		@file_exts = ['.svg', '.json']

		@go_back = '..'

		@help_hash = Hash.new(0)
	end
	def run
		while true
			if @counter == 3
				break
			end

			Dir.chdir(@go_back)
			Dir.chdir(@repositories[@counter])
			File.readlines(@text_files[@counter]).each do |line|
				@repo_links << line
			end
			Dir.chdir(@go_back)

			clone_and_run = Clone.new(@repo_links, @counter, @lines_num, @words_num, @count, @hash)
			@repositories_to_csv, @count, @words_num, @hash = clone_and_run.run()

			@repo_links.clear()
			@hash = @hash.sort_by { |key, value| [-value, key] }

			result = Result.new(@hash, @count, @words_num)
			result.to_svg(@file_names[@counter] + @file_exts[0])
			result.to_json(@file_names[@counter] + @file_exts[1])
			result.to_csv(@repositories_to_csv)

			@counter += 1
			@hash = @help_hash
			@count = 0
			@words_num = 0
		end
	end
end