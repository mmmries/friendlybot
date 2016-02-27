require 'bundler/setup'
require 'spyglass'
require './lib/face_picker'

include Spyglass

def scale_rect(rect, scale)
  width = (rect.width * scale).round
  height = (rect.height * scale).round
  cx = rect.point.x + (rect.width / 2)
  cy = rect.point.y + (rect.height / 2)
  x = (cx - (width / 2)).round
  y = (cy - (height / 2)).round
  Spyglass::Rect.new(x, y, width, height)
end

classifier  = CascadeClassifier.new("./haarcascade_frontalface_default.xml")
window      = GUI::Window.new "Video"
cap         = VideoCapture.new 0
frame       = Image.new
picker      = FacePicker.new

loop do
  cap >> frame

  rects = classifier.detect(frame, scale_factor: 1.5, min_size: Size.new(30, 30))
  rect = picker.pick(rects)
  if rect
    rect = scale_rect(rect, 1.5)
    frame.draw_rectangle(rect, Color.new(255, 0, 0)) if rect
  end

  window.show(frame)

  break if GUI::wait_key(100) > 0
end
