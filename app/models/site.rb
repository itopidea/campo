class Site
  include Mongoid::Document

  field :urlname
  field :name
  field :description
  field :domain

  belongs_to :owner, :class_name => 'User'
  has_and_belongs_to_many :admins, :class_name => 'User'

  attr_accessible :urlname, :name, :description

  validates_presence_of   :urlname, :name
  validates_format_of     :urlname, :with => /\A\w{3,20}\z/
  validates_uniqueness_of :urlname, :case_sensitive => false

  def urlname=(urlname)
    write_attribute :urlname, urlname unless self.urlname
  end
end
