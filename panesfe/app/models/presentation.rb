class Presentation < ActiveRecord::Base
  belongs_to :user
  validates :name, :user, presence: true
  validates :name, uniqueness: {scope: :user}

  def content
    ERB.new(File.read(File.join(Rails.root, 'lib', 'templates', 'slideshow.html.erb'))).result(binding)
  end
end
