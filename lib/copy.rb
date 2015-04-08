require 'fileutils'

# Handles copying of pictures to a specified directory
class Copy
  def initialize(report_errors)
    @report_errors = report_errors
  end

  def overwrite?(selected_pictures, target_directory)
    files = files_in_directory(target_directory)
    files_to_check = paths_to_basenames(selected_pictures)
    common = files & files_to_check
    !common.empty?
  end

  def copy(selected_pictures, target_directory)
    FileUtils.cp(selected_pictures, target_directory)
  rescue SystemCallError => e
    @report_errors.call(exception_to_string(e))
  end

  private

  def files_in_directory(directory)
    paths_to_basenames(Dir.glob("#{directory}/*").sort)
  end

  def paths_to_basenames(paths)
    paths.map { |f| File.basename(f) }
  end

  def exception_to_string(exception)
    exception.message.sub(/@.*- /, '')
  end
end
