# Stores the currently selected pictures
class SelectedPictures
  attr_accessor :source
  attr_reader :model

  def initialize(source, model)
    @source = source
    @model = model
  end

  def select_current
    return unless @source.current_picture
    @model << { picturePath: @source.current_picture }
  end
end
