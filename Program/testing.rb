require './lib/clone'
require './lib/result'

class Main
	def initialize(used_hash)
		@hash = used_hash

		@lines_num = 0.to_i
		@counter = 0.to_i
		@count = 0.to_i
		@repo_links = []
		@repositories_to_csv = []

		@repositories = ['Ruby_Repositories', 'CC_Repositories', 'Java_Repositories']
		@text_files = ['ruby_repos.txt', 'cc_repos.txt', 'java_repos.txt']
		@svg_names = ['ruby_repos.svg', 'cc_repos.svg', 'java_repos.svg']

		@go_back = '..'
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
			clone_and_run = Clone.new(@repo_links, @counter, @lines_num, @count, @hash)
			@repositories_to_csv = clone_and_run.run()

			@repo_links.clear()
			@hash = @hash.sort_by { |key, value| [-value, key] }

			result = Result.new(@svg_names[@counter], @hash, @count)
			result.to_svg()

			@counter += 1
			@hash.clear()
			@count = 0
		end
	end
end