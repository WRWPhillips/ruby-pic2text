require"rmagick"

image_path = ARGV[0]
image = Magick::ImageList.new(image_path)

terminal_width = 80.freeze 
ascii_density_map = {0 => " ", 1 => ".", 2 => ":", 3 => "-", 4 => "=", 5 => "+", 6 => "*", 7 => "#", 8 => "%", 9 => "@"}.freeze

img_width = image.columns
chunk_size = img_width / terminal_width
puts chunk_size
puts image.rows 
puts image.rows % chunk_size

image.quantize(256, Magick::GRAYColorspace)

pixels = image.get_pixels(0, 0, image.columns, (image.rows - image.rows % chunk_size))

# the next goal will be to iterate over pixels array, counting intensity by chunk.
# then I will need to create a tally of intensity per chunk, per row, until rows reach chunk size
# so say chunk size is six and rows are 480, I will need to take 80 intensity measurements on the first row of the array
# then I will need to take (height - height % chunk_size) / chunk_size more of these sets of intensity measurements