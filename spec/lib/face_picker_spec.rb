require 'spec_helper'
require 'face_picker'

describe ::FacePicker do
  it "filters smaller contained rects" do
    rects = [
      ::Spyglass::Rect.new(100,100,200,200),
      ::Spyglass::Rect.new(150,150,100,100) ]

    expect(subject.pick(rects)).to eq(rects.first)
    expect(subject.pick(rects.reverse)).to eq(rects.first)
  end

  it "picks the larger rect when multiple rectangles are found" do
    rects = [
      ::Spyglass::Rect.new(100,100,50,50),
      ::Spyglass::Rect.new(300,100,100,100) ]

    expect(subject.pick(rects)).to eq(rects.last)
  end
end
