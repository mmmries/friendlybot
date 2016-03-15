require_relative "goole_image_api"

class Analyzer
  attr_reader :filepath

  def initialize(filepath)
    @filepath = filepath
  end

  def analysis
    @analysis ||= GoogleImageAPI.request(filepath)
  end

  def blurry?
    enum = analysis["responses"].first["faceAnnotations"].first["blurredLikelihood"]
    enum_to_probability(enum) > 0.45
  end

  def expression
    probabilities = expression_probabilities.select{|key, val| val > 0.45}
    return :unknown if probabilities.empty?
    probabilities.sort{|(_k1, v1), (_k2, v2)| v2 <=> v1}.first.first
  end

  def expression_probabilities
    annotation = analysis["responses"].first["faceAnnotations"].first
    {
      :anger => enum_to_probability(annotation["angerLikelihood"]),
      :joy => enum_to_probability(annotation["joyLikelihood"]),
      :sorrow => enum_to_probability(annotation["sorrowLikelihood"]),
      :surprise => enum_to_probability(annotation["surpriseLikelihood"]),
    }
  end

private

  def enum_to_probability(enum)
    case enum
      when "VERY_LIKELY"
        0.9
      when "LIKELY"
        0.75
      when "POSSIBLE"
        0.60
      when "UNLIKELY"
        0.45
      when "VERY_UNLIKELY"
        0.30
      when "UNKNOWN"
        0.0
      else
        raise ArgumentError, "unknown enum value #{enum}"
    end
  end
end
