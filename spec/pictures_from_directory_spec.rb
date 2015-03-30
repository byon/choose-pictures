require 'pictures_from_directory'

RSpec.describe PicturesFromDirectory, 'construction' do
  it 'should have home directory as default path' do
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
    @pictures = PicturesFromDirectory.new
    mock_directory_glob([])
  end

  it 'should not have current picture' do
    expect(@pictures.current_picture).to eq nil
  end
end

RSpec.describe PicturesFromDirectory, 'directory without pictures' do
  before(:each) do
    @pictures = PicturesFromDirectory.new
    mock_directory_glob(%w( file.txt file.py file.rb ))
  end

  it 'should not have current picture' do
    expect(@pictures.current_picture).to eq nil
  end
end

RSpec.describe PicturesFromDirectory, 'one picture' do
  before(:each) do
    @pictures = PicturesFromDirectory.new
    mock_directory_glob(%w( file.jpg ))
  end

  it 'should have current picture' do
    expect(@pictures.current_picture).to match(/file.jpg/)
  end
end

def mock_directory_glob(result)
  allow(Dir).to receive(:glob).and_return(result)
end
