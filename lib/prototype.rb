require 'qml'

#
module Prototype
  VERSION = 1.0

  #
  class ImageChanges
    include QML::Access
    register_to_qml under: 'Prototype', version: '1.0'

    def initialize
      super
      @images = image_paths
      @current = 0
      @current_image = @images[@current]
    end

    def next_image
      return unless next?
      @current += 1
    end

    def previous_image
      return unless previous?
      @current -= 1
    end

    def current_image
      @images[@current]
    end

    def next?
      @current < @images.length - 1
    end

    def previous?
      @current > 0
    end

    private

    def image_paths
      matches = Dir.glob('data/*').sort.select { |i| i =~ /\.jpg/i }
      matches.map { |i| File.join(Dir.pwd, i) }
    end
  end
end

QML.run do |app|
  app.load_path Pathname(__FILE__) + '../prototype.qml'
end
