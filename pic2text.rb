# frozen_string_literal: true

require 'rmagick'

require './image'

# allows for feeding image and getting output via cli
image_path = ARGV[0]
# gets image and initializes variable
image = Magick::ImageList.new(image_path)

Image.new(image).call
return
