require 'qml'
require_relative 'pictures_from_directory'

# Allows control of the current picture from the UI
class CurrentPicture
  include QML::Access
  register_to_qml under: 'CurrentPicture', version: '1.0'

  def initialize
    super
    @pictures = PicturesFromDirectory.new
  end

  def default_directory
    ARGV[0] ? ARGV[0] : Dir.pwd
  end

  def use_directory(directory)
    @pictures.directory = directory
  end

  def current_picture
    return '' unless @pictures
    @pictures.current_picture ? @pictures.current_picture : ''
  end

  def move_to_first
    @pictures.first_picture
  end

  def move_to_previous
    @pictures.previous_picture
  end

  def move_to_next
    @pictures.next_picture
  end

  def move_to_last
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
