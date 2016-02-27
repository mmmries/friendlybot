class FacePicker
  def pick(rects)
    rects.sort_by(&:area).last
  end
end
