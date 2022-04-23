# frozen_string_literal: true
# gem import
require 'rmagick'
# require class
require './image'

# allows for feeding image via cli
puts ARGV[1].is_a?( String )
image_path = ARGV[0]
console_width = ARGV[1].to_i
# gets image and initializes variable
image = Magick::ImageList.new(image_path)
# calls image class with image passed as arg
Image.new(image, console_width).call
