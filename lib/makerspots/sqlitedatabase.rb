require 'active_record'

class SQLiteDatabase

  def initialize
    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database => 'makerspots.db'
    )
  end

  # Define models and relationships here (yes, classes within a class)
  class Checkin < ActiveRecord::Base
    belongs_to :location
    belongs_to :user
  end

  class Location < ActiveRecord::Base
    belongs_to :category
    has_many :checkins
  end

  class User < ActiveRecord::Base
    has_many :checkins
  end

  class Category < ActiveRecord::Base
    has_many :categories
  end

  def build_user(attrs)
    MakerSpots::User.new(attrs)
  end

  def create_user(attrs)
    ar_user = User.create(attrs)
    build_user(ar_user)
  end

  def get_user_by_id(id)
    ar_user = User.find(id)
    build_user(ar_user)
  end

  def get_user_by_email(email)
    ar_user = User.find_by(email: email)
    if ar_user
      build_user(ar_user)
    end
  end

  def build_location(attrs)
    MakerSpots::Location.new(attrs)
  end

  def create_location(attrs)
    ar_location = Location.create(attrs)
    build_location(ar_location)
  end

  def get_location(location_id)
    ar_location = Location.find_by(id: location_id)
    build_location(ar_location)
  end

  def get_all_locations
    ar_locations = Location.all
    ar_locations.map { |location| build_location(location) }
  end

  def get_locations_by_category(cat_id)
    ar_locations = Location.where(category_id: cat_id)

    ar_locations.map { |location| build_location(location) }
  end

  def build_checkin(attrs)
    MakerSpots::Checkin.new(attrs)
  end

  def create_checkin(attrs)
    ar_checkin = Checkin.create(attrs)
    build_checkin(ar_checkin)
  end

  def get_checkins_by_user(user_id)
    ar_checkin = Checkin.where(user_id: user_id, checked_in: true).first
    if ar_checkin
      build_checkin(ar_checkin)
    else
      return { error: "No active checkins found" }
    end
  end

  def get_checkins_by_location(location_id)
    ar_checkin = Checkin.where(location_id: location_id, checked_in: true)
    ar_checkin.map { |checkin| build_checkin(checkin) }
  end

  def checkout(user_id)
    ar_checkin = Checkin.where(user_id: user_id, checked_in: true).first
    if ar_checkin
      ar_checkin.update_attributes(checked_in: false)
      build_checkin(ar_checkin)
    end
  end

  def build_category(attrs)
    MakerSpots::Category.new(attrs)
  end

  def create_category(attrs)
    ar_category = Category.create(attrs)
    build_category(ar_category)
  end

end

module MakerSpots
  def self.db
    @___db_instance ||= SQLiteDatabase.new
  end
end
