class PresentationItem
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  belongs_to :presentation
end
