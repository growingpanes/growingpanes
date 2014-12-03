class Presentation
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  belongs_to :user
  has n, :presentation_items
end
