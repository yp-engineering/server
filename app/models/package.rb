class Package < ActiveRecord::Base
  has_many :client_packages
  def self.default_search_attribute
    'name'
  end

  def self.counts
    select("name, count(name) as count").
      group("name")
  end
end
