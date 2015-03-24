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
      @current_id = 1
    end

    def change
      @current_id = @current_id == 1 ? 2 : 1
      "data/pic#{@current_id}.jpg"
    end
  end
end

QML.run do |app|
  app.load_path Pathname(__FILE__) + '../main.qml'
end
