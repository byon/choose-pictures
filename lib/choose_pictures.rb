require 'qml'
require_relative 'copy_pictures'
require_relative 'current_picture'
require_relative 'selection'

if __FILE__ == $PROGRAM_NAME
  QML.run do |app|
    app.load_path Pathname(__FILE__) + '../main.qml'
  end
end
