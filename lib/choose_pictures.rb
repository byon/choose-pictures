require 'qml'
require_relative 'pictures_from_directory'

# Link between QML and application logic
class ChoosePictures
  include QML::Access
  register_to_qml under: 'ChoosePictures', version: '1.0'

  def initialize
    super
    @pictures = PicturesFromDirectory.new
  end

  def use_directory(directory)
    @pictures.directory = directory
  end

  def current_picture
    return '' unless @pictures
    @pictures.current_picture ? @pictures.current_picture : ''
  end

  def first_picture
    @pictures.first_picture
  end

  def previous_picture
    @pictures.previous_picture
  end

  def next_picture
    @pictures.next_picture
  end

  def last_picture
    @pictures.last_picture
  end

  # Temporarily disabling a few style warnings from Rubocop. The
  # normal method names for getters (e.g., previous? and next?) are
  # not valid code in QML.
  # rubocop:disable Style/PredicateName
  def has_previous
    @pictures.previous?
  end

  def has_next
    @pictures.next?
  end
  # rubocop:enable Style/PredicateName

  def allowed_extensions
    ALL_EXTENSIONS.map { |e| '*.' + e }.join(' ')
  end
end

QML.run do |app|
  app.load_path Pathname(__FILE__) + '../main.qml'
end
