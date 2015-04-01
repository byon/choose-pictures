require 'qml'
require_relative 'current_picture'

QML.run do |app|
  app.load_path Pathname(__FILE__) + '../main.qml'
end
