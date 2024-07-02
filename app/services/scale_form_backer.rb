class ScaleFormBacker
  include ActiveModel::Model

  attr_accessor :scale

  def initialize(scale = 4)
    @scale = scale&.to_i || 1
    @scale = 1 if @scale < 1
  end
end
