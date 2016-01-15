class Result
	def initialize(name, hash, count)
		@name = name
		@hash = hash
		@count = count

		@BONUS_PIXELS = 15
	end

	def gime_text x_,y_,word
		'<text x="'+x_.to_s+'" y="'+y_.to_s+'" fill="black">'+word.to_s+'</text>'
	end

	def gime_a_rect x_,y_,w_,h_
		'<rect x="'+x_.to_s+'" y="'+y_.to_s+'" width="'+w_.to_s+'" height="'+h_.to_s+'" 
		style="fill:rgb(0,255,0);stroke-width:2;stroke:rgb(0,0,0)" />'
	end

	def to_svg()
		max_width = 7000
		max_height = @hash[0][1]*20 + 100
		width_step = 10
		num_of_word = 0

		File.open(@name,"w") do |f|
			f.write('<svg xmlns="http://www.w3.org/2000/svg" width="'+max_width.to_s+'" height="'+max_height.to_s+'">')
			f.write(gime_text 0,10,'"Marks":')
			f.write(gime_text 50,10,@count)
			@hash.each do |word|
				x = width_step
				height = 20*@hash[num_of_word][1]
				h_step = max_height-height-25
				width = 60
				f.write(gime_a_rect width_step, h_step, width, height)
				f.write(gime_text x+width/2 , h_step+@hash[num_of_word][1]*10 , @hash[num_of_word][1])
				f.write(gime_text x+@BONUS_PIXELS , h_step+height+@BONUS_PIXELS , @hash[num_of_word][0])
				width_step = width_step + 70
				num_of_word = num_of_word + 1
			end
			f.write('</svg>')
		end
	end
end