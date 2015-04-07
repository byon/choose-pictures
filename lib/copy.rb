require 'fileutils'

# Handles copying of pictures to a specified directory
class Copy
  def initialize(report_errors)
    @report_errors = report_errors
  end

  def copy(selected_pictures, target_directory)
    FileUtils.cp(selected_pictures, target_directory)
  rescue SystemCallError => e
    @report_errors.call(exception_to_string(e))
  end

  private

  def exception_to_string(exception)
    exception.message.sub(/@.*- /, '')
  end
end
