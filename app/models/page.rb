class Page
  include Mongoid::Document
  field :url, type: String
  field :content, type: Hash

  validates :url, presence: true, format: URI::regexp(%w(http https))
end