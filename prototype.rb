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
      @images = next_image
    end

    def change
      @images.resume
    end

    private

    def next_image
      Fiber.new do
        loop do
          Dir.glob('data/*') do |image|
            next if image !~ /\.jpg/i
            Fiber.yield File.join(Dir.pwd, image)
          end
        end
      end
    end
  end
end

QML.run do |app|
  app.load_path Pathname(__FILE__) + '../main.qml'
end
