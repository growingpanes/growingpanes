require 'carrierwave/orm/activerecord'
class Presentation < ActiveRecord::Base
  belongs_to :user
  validates :name, :user, presence: true
  validates :name, uniqueness: {scope: :user}
  has_many :slides
  accepts_nested_attributes_for :slides, allow_destroy: true, reject_if: proc { |attributes| 
    attributes['image'].blank? && attributes['image_cache'].blank?
  }

  def content
    ApplicationController.new.render_to_string(:partial => 'presentations/slideshow', :object => self)
    #ERB.new(File.read(File.join(Rails.root, 'lib', 'templates', 'slideshow.html.erb'))).result(binding)
  end
end
