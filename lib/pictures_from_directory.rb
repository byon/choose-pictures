# Provides a way to enumerate picture files in a specific directory
class PicturesFromDirectory
  attr_reader :directory

  def initialize(directory = Dir.home)
    @directory = directory
    fail "\"#{@directory}\" does not exist" unless File.directory?(@directory)
  end

  def current_picture
    expression = Regexp.union(ALL_EXTENSIONS)
    matches = Dir.glob(directory + '/*').sort.select { |i| i =~ expression }
    matches.length > 0 ? matches[0] : nil
  end
end

EXTENSIONS = %w( jpg jpeg png )
ALL_EXTENSIONS = EXTENSIONS + EXTENSIONS.map(&:upcase)
