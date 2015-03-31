require 'qml'
require_relative 'pictures_from_directory'

# Link between QML and application logic
class ChoosePictures
  include QML::Access
  register_to_qml under: 'ChoosePictures', version: '1.0'

  def initalize
    super
  end

  def use_directory(directory)
    @pictures = PicturesFromDirectory.new(directory)
  end

  def current_picture
    return '' unless @pictures
    @pictures.current_picture ? @pictures.current_picture : ''
  end

  def allowed_extensions
    ALL_EXTENSIONS.map { |e| '*.' + e }.join(' ')
  end
end

QML.run do |app|
  app.load_path Pathname(__FILE__) + '../main.qml'
end
