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
    index = find_insertion_index @source.current_picture
    @model.insert(index, picturePath: @source.current_picture) if index
  end

  def remove_current
    current = find_picture @source.current_picture
    @model.delete_at(current) if current
  end

  def selected?(to_check)
    !find_picture(to_check).nil?
  end

  def selection?
    @model.map { |s| s[:picturePath] }
  end

  def index?(to_find)
    index = find_picture to_find
    index ? index : -1
  end

  private

  def find_picture(to_find)
    @model.find_index do |i|
      i[:picturePath] == to_find
    end
  end

  def find_insertion_index(new_picture)
    return 0 if @model.count == 0
    index = @model.find_index { |p| new_picture <= p[:picturePath] }
    return @model.count unless index
    return nil if @model[index][:picturePath] == new_picture
    index
  end
end
