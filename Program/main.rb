require 'json'

$repo_links = []
$repositories_to_csv = []

$repositories = ['Ruby_Repositories', 'CC_Repositories', 'Java_Repositories']
$text_files = ['ruby_repos.txt', 'cc_repos.txt', 'java_repos.txt']
$cloning_folder = 'test'
$expected_extentions = ['.rb', ['.cc', '.cpp', '.h'], '.java']

$counter = 0.to_i
BONUS_PIXELS = 15
$words_num = 0.to_i
$lines_num = 0.to_i

$hash = Hash.new(0)
$count = 0.to_i
copy_hash = Hash.new(0)

def clone_and_run(repo_links)
	Dir.chdir($cloning_folder)

	repo_links.each do |link|
	  #`git clone #{link}`

	  repo_name = link.split('/').last
	  repo_name = repo_name.split('.').first
	  repo_name = repo_name.chomp

	  Dir.chdir(repo_name)

	  globbing()

	  $repositories_to_csv << "#{link},#{$lines_num}"

	  Dir.chdir('..')
	  $lines_num = 0.to_i
	end
end

def globbing
	Dir.glob('*').each do |filename|
		if File.file?(filename)
			after_dot = filename.split('.').last

			#run(after_dot, expected_extentions[counter], filename)
			if $expected_extentions[$counter].include? File.extname(after_dot)
				$lines_num += `wc -l "#{filename}"`.strip.split(' ')[0].to_i
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
		$words_num += 1
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

def gime_text x_,y_,word
	'<text x="'+x_.to_s+'" y="'+y_.to_s+'" fill="black">'+word.to_s+'</text>'
end

def gime_a_rect x_,y_,w_,h_
	'<rect x="'+x_.to_s+'" y="'+y_.to_s+'" width="'+w_.to_s+'" height="'+h_.to_s+'" 
	style="fill:rgb(0,255,0);stroke-width:2;stroke:rgb(0,0,0)" />'
end

def make_svg(name)
	max_width = 7*$words_num
	max_height = $hash[0][1]*20 + 100
	width_step = 10
	num_of_word = 0

	File.open(name,"w") do |f|
		f.write('<svg xmlns="http://www.w3.org/2000/svg" width="'+max_width.to_s+'" height="'+max_height.to_s+'">')
		f.write(gime_text 0,10,'"Marks":')
		f.write(gime_text 50,10,$count)
		$hash.each do |word|
			x = width_step
			height = 20*$hash[num_of_word][1]
			h_step = max_height-height-25
			width = 60
			f.write(gime_a_rect width_step, h_step, width, height)
			f.write(gime_text x+width/2 , h_step+$hash[num_of_word][1]*10 , $hash[num_of_word][1])
			f.write(gime_text x+BONUS_PIXELS , h_step+height+BONUS_PIXELS , $hash[num_of_word][0])
			width_step = width_step + 70
			num_of_word = num_of_word + 1
		end
		f.write('</svg>')
	end
end

def make_csv
	File.open('repositories.csv', 'w') do |csv|
		csv.write($repositories_to_csv)
	end
end
def most_used_words_to_csv(most_used)
	File.open('most_used_words_in_languages.csv',  'w') do |csv|
		csv.write(most_used)
	end
end

def make_json(name)
	tempHash = Hash.new(0)

	tempHash = {
		"marks" => $count,
		"words" => $hash
	}

	json_hash = JSON.pretty_generate(tempHash)

	File.open(name, 'w') do |file|
		file << json_hash
	end
end

most_used = []

while true
	if $counter == 3
		make_csv()
		most_used_words_to_csv(most_used)
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

	$hash = $hash.sort_by { |key, value| [-value, key] }
	#copy_hash.merge($hash) { |key, oldval, newval| oldval + newval }

	if $counter == 0
		make_json('ruby')
		make_svg('ruby')
		ruby_word = $hash[0][0]
		most_used << "Ruby -> #{ruby_word}"
	elsif $counter == 1
		make_json('c++')
		make_svg('c++')
		cc_word = $hash[0][0]
		most_used << "C++ -> #{cc_word}"
	elsif $counter == 2
		make_json('java')
		make_svg('java')
		java_word = $hash[0][0]
		most_used << "Java -> #{java_word}"
	end

	$hash.clear
	$words_num = 0.to_i
end

#https://github.com/layervault/psd.rb.git
#https://github.com/octokit/octokit.rb.git