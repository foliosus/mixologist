class Garnish < ActiveRecord::Base
  has_and_belongs_to_many :cocktails, inverse_of: :garnishes

  default_scope lambda{ order('name ASC') }

  validates_presence_of :name

  # =============
  # Import/export
  # =============

  def self.import_from_hash(hsh)
    garnish = find_or_initialize_by(hsh.slice(:name))
    garnish.update(hsh)
    garnish
  end

  def to_hash
    {
      name: name
    }
  end
end
