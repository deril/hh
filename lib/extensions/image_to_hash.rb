require 'RMagick'

module ImageToHash
  class HashMaker
    class << self
      def make_hash(image_path)
        # TODO: image  or path
        return unless File.exist?(image_path)

        begin
          image = Magick::Image.read(image_path).first
        rescue
          return nil
        end

        image = image.resize(65, 65).quantize(256, Magick::GRAYColorspace).crop(1,1, 64, 64)

        brightnesses = []
        image.each_pixel{|pixel, r, c| brightnesses << (0.2126*pixel.red) + (0.7152*pixel.green) + (0.0722*pixel.blue) }

        average_brightness = brightnesses.inject(:+) / brightnesses.size

        hash_brightness = ''
        brightnesses.each{|elem| hash_brightness << ((elem < average_brightness) ? '0' : '1') }

        hash_brightness.to_i(2).to_s(16)
      end

      def compare_hashes(hash_1, hash_2)
        return unless hash_1.present? && hash_2.present?
        diff_count = 0
        hash_1.split('').each_with_index{|el, i| diff_count += 1 unless el == hash_2[i] }

        diff_percentage = diff_count/(hash_1.size/100)
        diff_percentage
      end
    end
  end
end