require 'qml'
require_relative 'copy'

# Allows copying of the selected pictures from the UI
class CopyPictures
  include QML::Access
  register_to_qml under: 'CopyPictures', version: '1.0'

  def initialize
    super
  end

  def copy_pictures(controller, selected_pictures, target_directory)
    copier = Copy.new(-> e { controller.show_error e })
    if copier.overwrite?(selected_pictures, target_directory)
      controller.ask_overwrite_permission
      return
    end
    copier.copy(selected_pictures, target_directory)
  end

  def force_copy_pictures(controller, selected_pictures, target_directory)
    copier = Copy.new(-> e { controller.show_error e })
    copier.copy(selected_pictures, target_directory)
  end
end
