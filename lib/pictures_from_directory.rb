# Provides a way to enumerate picture files in a specific directory
class PicturesFromDirectory
  attr_reader :directory

  def initialize(directory = Dir.home)
    @directory = directory
    fail "\"#{@directory}\" does not exist" unless File.directory?(@directory)
    @pictures = read_pictures @directory
    @current = 0
  end

  def current_picture
    @pictures[@current]
  end

  def previous_picture
    return unless previous?
    @current -= 1
  end

  def next_picture
    return unless next?
    @current += 1
  end

  def previous?
    @current > 0
  end

  def next?
    @current + 1 < @pictures.length
  end

  private

  def read_pictures(directory)
    expression = Regexp.union(ALL_EXTENSIONS)
    Dir.glob(directory + '/*').select { |i| i =~ expression }
  end
end

EXTENSIONS = %w( jpg jpeg png )
ALL_EXTENSIONS = EXTENSIONS + EXTENSIONS.map(&:upcase)
