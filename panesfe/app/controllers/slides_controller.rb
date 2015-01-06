class SlidesController < ApplicationController
  before_action :set_presentation, only: [:index, :new, :create]

  def index
  end

  def create
    params[:files].each do |file|
      slide = @presentation.slides.build
      slide.image = file
    end
    @presentation.save!
    redirect_to presentation_slides_path(@presentation)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_presentation
      @presentation = Presentation.find(params[:presentation_id])
    end
end
