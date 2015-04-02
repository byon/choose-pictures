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
    return if find_picture @source.current_picture
    @model << { picturePath: @source.current_picture }
  end

  def remove_current
    current = find_picture @source.current_picture
    @model.delete_at(current) if current
  end

  def selected?(to_check)
    !find_picture(to_check).nil?
  end

  private

  def find_picture(to_find)
    @model.find_index do |i|
      i[:picturePath] == to_find
    end
  end
end
