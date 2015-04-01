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

  it 'should look for any files from the directory' do
    glob = expect_directory_glob
    PicturesFromDirectory.new('.')
    glob.valid?
  end
end

RSpec.describe PicturesFromDirectory, 'changing directory' do
  it 'should look for any files from the changed directory' do
    pictures = PicturesFromDirectory.new
    glob = expect_directory_glob('changed/*', %w(file1.jpg file2.jpg))
    pictures.directory = 'changed'
    expect(pictures.directory).to eq 'changed'
    glob.valid?
  end

  it 'should reset to first file in directory' do
    mock_directory_glob(%w(original1.jpg original2.jpg))
    pictures = PicturesFromDirectory.new
    pictures.next_picture

    mock_directory_glob(%w(file1.jpg file2.jpg))
    pictures.directory = 'changed'

    expect(pictures.current_picture).to eq 'file1.jpg'
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

  it 'should not have next picture' do
    expect(@pictures.next?).to eq false
  end

  it 'should not have previous picture' do
    expect(@pictures.previous?).to eq false
  end

  it 'should do nothing when moving to first picture' do
    @pictures.first_picture
    expect(@pictures.current_picture).to eq nil
  end

  it 'should do nothing when moving to last picture' do
    @pictures.last_picture
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

  it 'should not have next picture' do
    expect(@pictures.next?).to eq false
  end

  it 'should not have previous picture' do
    expect(@pictures.previous?).to eq false
  end

  it 'should do nothing when moving to first picture' do
    @pictures.first_picture
    expect(@pictures.current_picture).to eq nil
  end

  it 'should do nothing when moving to last picture' do
    @pictures.last_picture
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

  it 'should not have next picture' do
    expect(@pictures.next?).to eq false
  end

  it 'should not have previous picture' do
    expect(@pictures.previous?).to eq false
  end

  it 'should do nothing when moving to next picture' do
    10.times { @pictures.next_picture }
    expect(@pictures.current_picture).to match(/file.jpg/)
  end

  it 'should do nothing when moving to previous picture' do
    10.times { @pictures.previous_picture }
    expect(@pictures.current_picture).to match(/file.jpg/)
  end

  it 'should do nothing when moving to first picture' do
    @pictures.first_picture
    expect(@pictures.current_picture).to match(/file.jpg/)
  end

  it 'should do nothing when moving to last picture' do
    @pictures.last_picture
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

  it 'should have next picture' do
    expect(@pictures.next?).to eq true
  end

  it 'should not have previous picture' do
    expect(@pictures.previous?).to eq false
  end

  it 'should show first picture as current when moving back and forth' do
    @pictures.next_picture
    @pictures.previous_picture
    expect(@pictures.current_picture).to match(/file1.jpg/)
  end

  it 'should have previous picture after moving next' do
    @pictures.next_picture
    expect(@pictures.previous?).to eq true
  end

  it 'should do nothing when moving to previous picture' do
    @pictures.previous_picture
    expect(@pictures.current_picture).to match(/file1.jpg/)
  end

  it 'should do nothing when moving to next when at end' do
    100.times { @pictures.next_picture }
    expect(@pictures.current_picture).to match(/file10.jpg/)
  end

  it 'should do nothing when moving to first picture from start' do
    @pictures.first_picture
    expect(@pictures.current_picture).to match(/file1.jpg/)
  end

  it 'should do nothing when moving to last picture from end' do
    100.times { @pictures.next_picture }
    @pictures.last_picture
    expect(@pictures.current_picture).to match(/file10.jpg/)
  end

  it 'should show first picture when moving to first picture' do
    5.times { @pictures.next_picture }
    @pictures.first_picture
    expect(@pictures.current_picture).to match(/file1.jpg/)
  end

  it 'should show last picture when moving to last picture' do
    5.times { @pictures.next_picture }
    @pictures.last_picture
    expect(@pictures.current_picture).to match(/file10.jpg/)
  end
end

def mock_directory_glob(result)
  allow(Dir).to receive(:glob).and_return(result)
end

def expect_directory_glob(expected = './*', result = [])
  glob = double.as_null_object
  expect(Dir).to receive(:glob).with(expected) { glob } .and_return(result)
  glob
end
