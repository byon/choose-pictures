require 'qml'
require_relative 'selected_pictures'

# Allows control of the selection from the UI
class Selection
  include QML::Access
  register_to_qml under: 'Selection', version: '1.0'

  property :model, QML::Data::ArrayModel.new(:picturePath)

  def link_current_to_selection(current_picture)
    @selected_pictures = SelectedPictures.new(current_picture, model)
  end

  def select_current
    @selected_pictures.select_current
  end
end
