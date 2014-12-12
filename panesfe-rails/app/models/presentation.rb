class Presentation < ActiveRecord::Base
  belongs_to :user
  validates :name, :user, presence: true
  validates :name, uniqueness: {scope: :user}

  def content
    "<html><body><h1>Hello Video Wall</h1></body></html>"
  end
end