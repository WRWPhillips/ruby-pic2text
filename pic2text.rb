# frozen_string_literal: true
# gem import
require 'rmagick'
# require class
require './image'

# allows for feeding image via cli
image_path = ARGV[0]
console_width = 80 || ARGV[1]
# gets image and initializes variable
image = Magick::ImageList.new(image_path)
# calls image class with image passed as arg
Image.new(image).call
