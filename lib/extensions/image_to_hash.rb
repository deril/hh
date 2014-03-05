# require 'RMagick'

module ImageToHash
  def make_hash(image_path)
    image = QuickMagick::Image.read(image_path).first
    return unless image

    # FIXME: problem how to make image grayscale!!!
    image = image.resize(65, 65).quantize(256, ImageMagick::GRAYColorspace).crop(1,1, 64, 64)

    brightnesses = []
    image.each_pixel{|pixel, r, c| brightnesses << (0.2126*pixel.red) + (0.7152*pixel.green) + (0.0722*pixel.blue) }

    average_brightness = brightnesses.inject(:+) / brightnesses.size
    hash_brightness = ''
    brightnesses.each{|elem| hash_brightness << ((elem < average_brightness) ? '0' : '1') }
    hash_brightness.to_i(2).to_s(16)
  end

  def compare_hashes(hash_1, hash_2)
    diff_count = 0
    hash_1.split('').each_with_index{|el, i| diff_count += 1 unless el == hash_2[i] }

    diff_percentage = diff_count/(hash_1.size/100)
    diff_percentage
  end

  private
    def statistics(all, diff)
      p "diff = #{diff}"
      p "all = #{all}"
      p "percent = #{diff/(all/100)}%"
      nil
    end
end