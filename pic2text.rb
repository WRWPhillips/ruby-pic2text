require"rmagick"

#allows for feeding image and getting output via cli
image_path = ARGV[0]
#gets image and initializes variable
image = Magick::ImageList.new(image_path)

#useful proportion for command line output
terminal_width = 80.freeze 
#standard density map found online in hash
ascii_density_map = {0 => " ", 1 => ".", 2 => ":", 3 => "-", 4 => "=", 5 => "+", 6 => "*", 7 => "#", 8 => "%", 9 => "@"}.freeze

#putting image in grayscale
image.quantize(256, Magick::GRAYColorspace)

#establishing image width and chunk size
img_width = image.columns - image.columns % terminal_width
chunk_size = img_width / terminal_width
img_height = image.rows - image.rows % chunk_size 

#function for extracting brightness from pixel
def brightness(pixel)
    Math.sqrt(
        0.299 * pixel.red**2 +
        0.587 * pixel.green**2 + 
        0.114 * pixel.blue**2 
    ).to_i
end

#removes bottom pixels that dont fit into chunk size constraint, gets array of pixels
pixels = image.get_pixels(0, 0, img_width, img_height)

chunk_array = []
chunk_intensity = 0
pixels.each_index do |i|
    if  (i + 1) % chunk_size != 0 
        chunk_intensity += brightness(pixels[i])
    else 
        chunk_array.append(chunk_intensity / chunk_size)
        chunk_intensity = brightness(pixels[i])
    end
end

modifier = 0
intensity_array = []
chunk_array.each_index do |i|
    if i >= img_width-1
        chunk_array[i - img_width * (i / img_width) -1] += chunk_array[i]
        if i +1 == img_width * chunk_size
            intensity_array.append(chunk_array.slice!(0, img_width * chunk_size - 1))
        end 
    end
end 

intensity_array[0].each do |x|
    puts (10.fdiv(x) * 10).to_i
end 
# the next goal will be to iterate over pixels array, counting intensity by chunk.
# then I will need to create a tally of intensity per chunk, per row, until rows reach chunk size
# so say chunk size is six and rows are 480, I will need to take 80 intensity measurements on the first row of the array
# then I will need to take (height - height % chunk_size) / chunk_size more of these sets of intensity measurements