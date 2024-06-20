class Garnish < ActiveRecord::Base
  has_and_belongs_to_many :cocktails, inverse_of: :garnishes

  default_scope lambda{ order('name ASC') }

  validates_presence_of :name

  def to_hash
    {
      name: name
    }
  end
end
