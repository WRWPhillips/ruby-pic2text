# frozen_string_literal: true

class Image
  TERMINAL_WIDTH = 120
  ASCII_DENSITY = ' .:-=+*#%@'.chars

  def initialize(image)
    raise ArgumentError unless image.is_a?(Magick::ImageList)

    @image = image
  end

  def call
    chunks.each do |row|
      puts row.map { |i| ASCII_DENSITY.fetch(i) }.join
    end
  end

  private

  attr_reader :image

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

  def pixel_at(x, y)
    pixels[y * width + x]
  end

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

  def brightness(pixel)
    ((scale(pixel.red) + scale(pixel.green) + scale(pixel.blue)) / 3).to_i
  end

  def scale(portion)
    portion / 65_535.0 * ASCII_DENSITY.length
  end

  def pixels
    @pixels ||= image.get_pixels(0, 0, width, height)
  end

  def width
    @width ||= image.columns - (image.columns % TERMINAL_WIDTH)
  end

  def height
    @height ||= image.rows - (image.rows % chunk_size)
  end

  def chunk_size
    @chunk_size ||= width / TERMINAL_WIDTH
  end
end
