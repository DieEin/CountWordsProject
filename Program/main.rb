repo_links = []

repositories = ['Ruby_Repositories', 'CC_Repositories', 'Java_Repositories']
text_files = ['ruby_repos.txt', 'cc_repos.txt', 'java_repos.txt']
cloning_folder = 'test'
expected_extentions = ['.rb', ['.cc', '.cpp', '.h'], '.java']
counter = 0.to_i

@hash = Hash.new(0)
@count = 0.to_i

def clone_and_run(repo_links)
	Dir.chdir(cloning_folder)

	repo_links.each do |link|
	  `git clone #{link}`

	  repo_name = link.split('/').last

	  Dir.chdir(repo_name)

	  globbing()

	  Dir.chdir('..')
	end
end

def globbing
	Dir.glob('*').each do |filename|
		if File.file?(filename)
			after_dot = filename.split('.').last

			#run(after_dot, expected_extentions[counter], filename)
			if after_dot.include?(expected_extentions[counter])
				parse_file(filename)
			end
		elsif File.directory?(filename)
			Dir.chdir(filename)
			globbing()
			Dir.chdir(..)
		end
	end
end

def parse(string)
	@count += string.scan(/[[:punct:]]/).count
	words = string.downcase.scan(/\w+/)

	words.each do |word|
		@hash[word] += 1
	end
end

def parse_file(filename)
	result = File.open(filename, 'r')
	result = result.read

	parse(result)
end

def run(extension, expected_extention, filename)
	if extension == expected_extention
		`ruby ../../Program/count_words.rb #{filename}`
	end
end

while true
	if counter == 3
		break
	end

	Dir.chdir('..')
	Dir.chdir(repositories[counter])
	File.readlines(text_files[counter]).each do |line|
		repo_links << line
	end

	Dir.chdir('..')

	clone_and_run(repo_links)

	repo_links.clear()
	counter++

	@hash.each do |key, value|
		puts "#{key},#{value}"
	end
end