require 'selected_pictures'

RSpec.describe SelectedPictures, 'construction' do
  before(:each) do
    @selected, @source, @model = create_selected_pictures(nil)
  end

  it 'should store source' do
    expect(@selected.source).to be @source
  end

  it 'should store model' do
    expect(@selected.model).to eq @model
  end

  it 'should set selection to empty' do
    expect(@selected.selection?).to eq []
  end
end

RSpec.describe SelectedPictures, 'selecting current picture' do
  before(:each) do
    @selected, @source, @model = create_selected_pictures('current')
  end

  it 'should store it in selection' do
    @selected.select_current
    expect(@selected.selection?).to eq %w(current)
  end

  it 'should add the picture to the model' do
    @selected.select_current
    expect(@model).to eq [{ picturePath: 'current' }]
  end

  it 'should be idempotent' do
    10.times { @selected.select_current }
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

RSpec.describe SelectedPictures, 'removing the only selection' do
  before(:each) do
    @selected, @source, @model = create_selected_pictures('current')
    @model << { picturePath: 'current' }
  end

  it 'should remove it from selection' do
    @selected.remove_current
    expect(@selected.selection?).to eq []
  end

  it 'should remove it from the model' do
    @selected.remove_current
    expect(@model).to eq []
  end
end

RSpec.describe SelectedPictures, 'removing from multiple selections' do
  before(:each) do
    @selected, @source, @model = create_selected_pictures(nil)
    @model << { picturePath: 'start' }
    @model << { picturePath: 'middle' }
    @model << { picturePath: 'end' }
  end

  it 'should remove current from the start' do
    @source.current_picture = 'start'
    @selected.remove_current
    expect(@model).to eq expected_model %w(middle end)
  end

  it 'should remove current from the end' do
    @source.current_picture = 'end'
    @selected.remove_current
    expect(@model).to eq expected_model %w(start middle)
  end

  it 'should remove current from the middle' do
    @source.current_picture = 'middle'
    @selected.remove_current
    expect(@model).to eq expected_model %w(start end)
  end

  it 'should do nothing if current is not selected' do
    @source.current_picture = 'not selected'
    @selected.remove_current
    expect(@model).to eq expected_model %w(start middle end)
  end

  def expected_model(paths)
    paths.map { |p| { picturePath: p } }
  end
end

RSpec.describe SelectedPictures, 'removing without selection' do
  before(:each) do
    @selected, @source, @model = create_selected_pictures('current')
  end

  it 'should do nothing' do
    @selected.remove_current
    expect(@model).to eq []
  end
end

RSpec.describe SelectedPictures, 'removing without current picture' do
  before(:each) do
    @selected, @source, @model = create_selected_pictures(nil)
  end

  it 'should do nothing' do
    @selected.remove_current
    expect(@model).to eq []
  end
end

RSpec.describe SelectedPictures, 'checking if selected' do
  before(:each) do
    @selected, @source, @model = create_selected_pictures('current')
  end

  it 'should be false if there is nothing selected' do
    expect(@selected.selected? 'meanginless').to eq false
  end

  it 'should be true if picture is selected' do
    @model << { picturePath: 'selected' }
    expect(@selected.selected? 'selected').to eq true
  end

  it 'should be false if other picture is selected' do
    @model << { picturePath: 'something else' }
    expect(@selected.selected? 'selected').to eq false
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
