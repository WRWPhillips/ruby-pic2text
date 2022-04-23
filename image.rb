# frozen_string_literal: true

# image class
class Image
  # variable terminal width, optional 2nd arg

  # string of ascii densities I found online
  ASCII_DENSITY = '$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\|()1{}[]?-_+~<>i!lI;:,"^`. '.chars.reverse()

  # initialize 
  def initialize(image, terminal_width)
    raise ArgumentError unless image.is_a?(Magick::ImageList)
    @image = image
    raise ArgumentError unless terminal_width.is_a? Integer
    @terminal_width = terminal_width
  end

  # the only public function, calls chunks which is the next last function
  # fetches and prints one row at a time
  def call
    chunks.each do |row|
      puts row.map { |i| ASCII_DENSITY.fetch(i) }.join
    end
  end

  # beginning of private
  private

  # allows for reading attrs of image
  attr_reader :image
  attr_reader :terminal_width 
  # 2 nested for loops, actually collects chunks into array of brightnesses
  def chunk(x, y)
    sum = 0
    chunk_starts_x = x * chunk_size
    chunk_starts_y = y * chunk_size

    (0...chunk_size).each do |x|
      (0...chunk_size).each do |y|
        current_pixel = pixel_at(chunk_starts_x + x, chunk_starts_y + y)
        sum += brightness(current_pixel)
      end
    end

    sum / (chunk_size * chunk_size)
  end

  # util to find pixel at xy coord
  def pixel_at(x, y)
    pixels[y * width + x]
  end

  # creates chunks!
  def chunks
    result_array = []
    (0...(height / chunk_size)).each do |y|
      result_array[y] = []

      (0...(width / chunk_size)).each do |x|
        result_array.last << chunk(x, y)
      end
    end
    result_array
  end

  # util function to return brightness of pixel
  def brightness(pixel)
    ((scale(pixel.red) + scale(pixel.green) + scale(pixel.blue)) / 3).to_i
  end
  
  # uses max 16 bit integer because for some reason this library gives 16 bit rgb values
  def scale(portion)
    portion / 65_535.0 * ASCII_DENSITY.length
  end

  # functions using or equals to basically create variables on demand
  def pixels
    @pixels ||= image.get_pixels(0, 0, width, height)
  end

  def width
    @width ||= image.columns - (image.columns % terminal_width)
  end

  def height
    @height ||= image.rows - (image.rows % chunk_size)
  end

  def chunk_size
    @chunk_size ||= width / terminal_width
  end
end
