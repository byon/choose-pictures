require 'selected_pictures'

RSpec.describe SelectedPictures, 'construction' do
  before(:each) do
    @selected, @source, @model = create_selected_pictures(nil)
  end

  it 'will store source' do
    expect(@selected.source).to be @source
  end

  it 'will store model' do
    expect(@selected.model).to eq @model
  end
end

RSpec.describe SelectedPictures, 'selecting current picture' do
  before(:each) do
    @selected, @source, @model = create_selected_pictures('current')
  end

  it 'should store it in selection' do
    @selected.select_current
    expect(@model).to eq [{ picturePath: 'current' }]
  end
end

RSpec.describe SelectedPictures, 'selecting when there is no current picture' do
  before(:each) do
    @selected, @source, @model = create_selected_pictures(nil)
  end

  it 'should do nothing' do
    @selected.select_current
    expect(@model).to eq []
  end
end

def create_selected_pictures(current_picture)
  source = PicturesDouble.new(current_picture)
  model = []
  selected = SelectedPictures.new(source, model)

  [selected, source, model]
end

# Double class for current picture source
class PicturesDouble
  attr_accessor :current_picture

  def initialize(current_picture)
    @current_picture = current_picture
  end
end
