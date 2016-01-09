repo_links = []

Dir.chdir('..')
Dir.chdir('Ruby_Repositories')

File.readlines('ruby_repos.txt').each do |line|
	repo_links << line
end

Dir.chdir('..')
Dir.chdir('test')

repo_links.each do |link|
	`git clone #{link}`

	repo_name = link.split('/').last

	Dir.chdir(repo_name)
	Dir.glob('*').each do |filename|
		after_dot = filename.split('.').last

		if after_dot == 'rb'
			`ruby ../../Program/count_words.rb #{filename}`
		end
	end

	Dir.chdir('..')
end