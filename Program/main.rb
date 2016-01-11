$repo_links = []

$repositories = ['Ruby_Repositories', 'CC_Repositories', 'Java_Repositories']
$text_files = ['ruby_repos.txt', 'cc_repos.txt', 'java_repos.txt']
$cloning_folder = 'test'
$expected_extentions = ['.rb', ['.cc', '.cpp', '.h'], '.java']
$counter = 0.to_i

BONUS_PIXELS = 15

$hash = Hash.new(0)
$count = 0.to_i

def clone_and_run(repo_links)
	Dir.chdir($cloning_folder)

	repo_links.each do |link|
	  `git clone #{link}`

	  repo_name = link.split('/').last
	  repo_name = repo_name.split('.').first
	  repo_name = repo_name.chomp

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
			if $expected_extentions[$counter].include? File.extname(after_dot)
				parse_file(filename)
			end
		elsif File.directory?(filename)
			Dir.chdir(filename)
			globbing()
			Dir.chdir('..')
		end
	end
end

def parse(string)
	$count += string.scan(/[[:punct:]]/).count
	words = string.downcase.scan(/\w+/)

	words.each do |word|
		$hash[word] += 1
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
	if $counter == 3
		break
	end

	Dir.chdir('..')
	Dir.chdir($repositories[$counter])
	File.readlines($text_files[$counter]).each do |line|
		$repo_links << line
	end

	Dir.chdir('..')

	clone_and_run($repo_links)

	$repo_links.clear
	$counter += 1

	$hash.each do |key, value|

		def gime_text x_,y_,word
			'<text x="'+x_.to_s+'" y="'+y_.to_s+'" fill="black">'+word.to_s+'</text>'
		end

		def gime_a_rect x_,y_,w_,h_
			'<rect x="'+x_.to_s+'" y="'+y_.to_s+'" width="'+w_.to_s+'" height="'+h_.to_s+'" 
			style="fill:rgb(0,255,0);stroke-width:2;stroke:rgb(0,0,0)" />'
		end

		max_width = 70*words_num
		max_height = result.word_counter[0][1]*20 + 100
		width_step = 10
		num_of_word = 0
		

		File.open("Most_used_words.svg","w") do |f|
			f.write('<svg xmlns="http://www.w3.org/2000/svg" width="'+max_width.to_s+'" height="'+max_height.to_s+'">')
			f.write(gime_text 0,10,'"Marks":')
			f.write(gime_text 50,10,result.marks_counter)
			result.word_counter.each do |word|
				x = width_step
				height = 20*result.word_counter[num_of_word][1]
				h_step = max_height-height-25
				width = 60
				f.write(gime_a_rect width_step, h_step, width, height)
				f.write(gime_text x+width/2 , h_step+result.word_counter[num_of_word][1]*10 , result.word_counter[num_of_word][1])
				f.write(gime_text x+BONUS_PIXELS , h_step+height+BONUS_PIXELS , result.word_counter[num_of_word][0])
				width_step = width_step + 70
				num_of_word = num_of_word + 1
			end
			f.write('</svg>')
		end
		result
	end
end
