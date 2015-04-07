require 'copy'
require 'fileutils'

TEST_DIRECTORY = File.join(Dir.pwd, 'directory_for_testing')
SOURCE_DIRECTORY = File.join(TEST_DIRECTORY, 'source')
TARGET_DIRECTORY = File.join(TEST_DIRECTORY, 'target')

shared_context 'test helpers for copy' do |create_target = true|
  before do
    FileUtils.rm_rf TEST_DIRECTORY
    FileUtils.mkdir_p SOURCE_DIRECTORY
    FileUtils.mkdir_p TARGET_DIRECTORY if create_target

    @source_paths = create_source_files 5
    @source_files = @source_paths.map { |f| File.basename f }

    @errors = []
    @copier = Copy.new(-> (e) { @errors << e })
  end

  after do
    FileUtils.rm_rf TEST_DIRECTORY
  end

  def test(sources)
    @copier.copy(sources, TARGET_DIRECTORY)
  end

  def copied_files
    Dir.glob(TARGET_DIRECTORY + '/*').sort.map { |f| File.basename f }
  end

  def create_source_files(count)
    files = source_files(count)
    files.map { |f| FileUtils.touch(f) }
    files
  end

  def source_files(count)
    (1..count).map { |i| "#{SOURCE_DIRECTORY}/file#{i}.jpg" }
  end
end

RSpec.describe 'copying files' do
  include_context 'test helpers for copy'

  it 'with one file should succeed' do
    test([@source_paths[0]])
    expect(copied_files).to eq [@source_files[0]]
  end

  it 'with multiple files should succeed' do
    test(@source_paths)
    expect(copied_files).to eq @source_files
  end

  it 'with no files should do nothing' do
    test([])
    expect(copied_files).to eq []
  end
end

RSpec.describe 'with missing target folder' do
  include_context 'test helpers for copy', false

  it 'reported error should be about missing target' do
    test(@source_paths)
    # Note that the exception message is sort of weird from FileUtils.cp as it
    # says the file does not exist, when the entire directory is missing.
    missing_path = "#{TARGET_DIRECTORY}/#{@source_files[0]}"
    expect(@errors).to eq ["No such file or directory #{missing_path}"]
  end
end

RSpec.describe 'with read-only target folder' do
  include_context 'test helpers for copy'

  before do
    FileUtils.chmod('u-w', TARGET_DIRECTORY)
  end

  after do
    FileUtils.chmod('u+w', TARGET_DIRECTORY)
  end

  it 'reported error should be about missing permission' do
    test(@source_paths)
    path = "#{TARGET_DIRECTORY}/#{@source_files[0]}"
    expect(@errors).to eq ["Permission denied #{path}"]
  end
end

RSpec.describe 'with already deleted source file' do
  include_context 'test helpers for copy'

  before do
    FileUtils.rm(@source_paths[0])
  end

  it 'reported error should be about missing permission' do
    test([@source_paths[0]])
    expect(@errors).to eq ["No such file or directory #{@source_paths[0]}"]
  end
end
