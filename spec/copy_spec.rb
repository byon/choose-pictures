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

  def test_overwrite(sources)
    @copier.overwrite?(sources, TARGET_DIRECTORY)
  end

  def test_copy(sources)
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

  def create_target_file(name)
    FileUtils.touch(File.join(TARGET_DIRECTORY, name))
  end

  def source_files(count)
    (1..count).map { |i| "#{SOURCE_DIRECTORY}/file#{i}.jpg" }
  end
end

RSpec.describe 'overwrite check' do
  include_context 'test helpers for copy'

  it 'should fail if there are no files in directory' do
    expect(test_overwrite(['does_not_matter_its_not_there.jpg'])).to eq false
  end

  it 'should pass if there are is one file with same name' do
    create_target_file(@source_files[0])
    expect(test_overwrite([@source_paths[0]])).to eq true
  end

  it 'should fail if there are only unmatching files' do
    create_target_file('something_that_does_not_match.jpg')
    expect(test_overwrite([@source_paths[0]])).to eq false
  end

  it 'should pass if there is one matching files' do
    create_target_file(@source_files[0])
    create_target_file('a_file_that_does_not_match.jpg')
    expect(test_overwrite([@source_paths[0]])).to eq true
  end
end

RSpec.describe 'copying files' do
  include_context 'test helpers for copy'

  it 'with one file should succeed' do
    test_copy([@source_paths[0]])
    expect(copied_files).to eq [@source_files[0]]
  end

  it 'with multiple files should succeed' do
    test_copy(@source_paths)
    expect(copied_files).to eq @source_files
  end

  it 'with no files should do nothing' do
    test_copy([])
    expect(copied_files).to eq []
  end
end

RSpec.describe 'with missing target folder' do
  include_context 'test helpers for copy', false

  it 'reported error should be about missing target' do
    test_copy(@source_paths)
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
    test_copy(@source_paths)
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
    test_copy([@source_paths[0]])
    expect(@errors).to eq ["No such file or directory #{@source_paths[0]}"]
  end
end
