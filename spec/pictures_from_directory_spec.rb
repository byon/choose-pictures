require 'pictures_from_directory'

RSpec.describe PicturesFromDirectory, 'construction' do
  it 'should by default use home directory' do
    pictures = PicturesFromDirectory.new
    expect(pictures.directory).to eq Dir.home
  end

  it 'should allow specifying different directory' do
    pictures = PicturesFromDirectory.new(Dir.pwd)
    expect(pictures.directory).to eq Dir.pwd
  end

  it 'should raise error, if the directory does not exist' do
    expect { PicturesFromDirectory.new('-') }
      .to raise_error '"-" does not exist'
  end
end

RSpec.describe PicturesFromDirectory, 'empty directory' do
  before(:each) do
    mock_directory_glob([])
    @pictures = PicturesFromDirectory.new
  end

  it 'should not show current picture' do
    expect(@pictures.current_picture).to eq nil
  end
end

RSpec.describe PicturesFromDirectory, 'directory without pictures' do
  before(:each) do
    mock_directory_glob(%w( file.txt file.py file.rb ))
    @pictures = PicturesFromDirectory.new
  end

  it 'should not show current picture' do
    expect(@pictures.current_picture).to eq nil
  end
end

RSpec.describe PicturesFromDirectory, 'directory with one picture' do
  before(:each) do
    mock_directory_glob(%w( file.jpg ))
    @pictures = PicturesFromDirectory.new
  end

  it 'should show current picture' do
    expect(@pictures.current_picture).to match(/file.jpg/)
  end
end

RSpec.describe PicturesFromDirectory, 'directory with several pictures' do
  before(:each) do
    mock_directory_glob((1..10).map { |i| "file#{i}.jpg" })
    @pictures = PicturesFromDirectory.new
  end

  it 'should show first picture as current' do
    expect(@pictures.current_picture).to match(/file1.jpg/)
  end

  it 'should show second picture as current when moving to next' do
    @pictures.next_picture
    expect(@pictures.current_picture).to match(/file2.jpg/)
  end

  it 'should show first picture as current when moving back and forth' do
    @pictures.next_picture
    @pictures.previous_picture
    expect(@pictures.current_picture).to match(/file1.jpg/)
  end
end

def mock_directory_glob(result)
  allow(Dir).to receive(:glob).and_return(result)
end
