class Package < ActiveRecord::Base
  has_many :client_packages
  has_many :uploads, -> { order("updated_at DESC") }, primary_key: :filename, foreign_key: :upload_file_name

  def self.default_search_attribute
    'name'
  end

  def self.counts
    select("name, count(name) as count").
      group("name")
  end
end
