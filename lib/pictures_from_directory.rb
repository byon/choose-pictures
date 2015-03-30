# Provides a way to enumerate picture files in a specific directory
class PicturesFromDirectory
  attr_reader :directory

  def initialize(directory = Dir.home)
    @directory = directory
    fail "\"#{@directory}\" does not exist" unless File.directory?(@directory)
  end

  def current_picture
    expression = picture_expression
    matches = Dir.glob(directory + '/*').sort.select { |i| i =~ expression }
    matches.length > 0 ? matches[0] : nil
  end

  private

  def picture_expression
    extensions = %w( jpg jpeg png )
    Regexp.union(extensions + extensions.map(&:upcase))
  end
end
