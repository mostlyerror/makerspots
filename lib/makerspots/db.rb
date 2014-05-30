require 'pry'
require 'sqlite3'
class MakerSpots::DB

  def initialize
    # Database method
    @db = SQLite3::Database.new "makerspots.db"

    @db.execute(
      "CREATE TABLE if not exists locations(
      id integer,
      name string NOT NULL,
      description string NOT NULL,
      phone string,
      address string NOT NULL,
      PRIMARY KEY (id)
      )"
      )

    @db.execute(
      "CREATE TABLE if not exists users(
      id integer,
      name string NOT NULL,
      email string NOT NULL UNIQUE,
      password string NOT NULL,
      PRIMARY KEY (id)
      )"
    )

    @db.execute(
      "CREATE TABLE if not exists checkins(
        id integer,
        location_id integer,
        user_id integer,
        checked_in boolean,
        created_at datetime,
        PRIMARY KEY (id)
      )"
    )
  end

  def build_location(data)
    MakerSpots::Location.new(data)
  end

  def create_location(data)
    # Input: hash, data, name[string], description[string], phone[string], address[string]. Name, desc, address required
    # Output: Location object

    @db.execute(
      "INSERT INTO locations (name, description, phone, address)
      VALUES (?,?,?,?)",
      data[:name], data[:description], data[:phone], data[:address]
      )

    data = @db.execute(
      "SELECT * FROM locations where id = last_insert_rowid()"
    ).flatten

    data_hash = {
      id: data[0],
      name: data[1],
      description: data[2],
      phone: data[3],
      address: data[4]
    }

    build_location(data_hash)
  end

  def get_location(id)
    # Input: id[integer]
    # Output: Location object

    data = @db.execute(
      "SELECT * FROM locations
      WHERE id = ?", id
    ).flatten

    data_hash = {
      id: data[0],
      name: data[1],
      description: data[2],
      phone: data[3],
      address: data[4]
    }

    build_location(data_hash)
  end

  def get_all_locations
    # Output: Array of Location objects. Ascending order by id

    locations_holder = []
    data = @db.execute(
      "SELECT * FROM locations"
    )

    # Data is array of arrays, l_data is inner array, contains location attributes
    data.each do |l_data|
      data_hash = {
        id: l_data[0],
        name: l_data[1],
        description: l_data[2],
        phone: l_data[3],
        address: l_data[4]
      }
      locations_holder << build_location(data_hash)
    end

    locations_holder
  end

  def get_all_locations_json
    records = @db.execute("SELECT * FROM locations")
    records.map! do |record|
      {
        id: record[0],
        name: record[1],
        description: record[2],
        phone: record[3],
        address: record[4]
      }
    end
    records
  end

  def build_user(data)
    MakerSpots::User.new(data)
  end

  def create_user(data)
    # Input: hash, data name[string], email[string], password[string]. All required
    # Output: User object

    @db.execute(
      "INSERT INTO users (name, email, password)
      VALUES (?,?,?)",
      data[:name], data[:email], data[:password]
    )

    data = @db.execute(
      "SELECT * FROM users where id = last_insert_rowid()"
    ).flatten

    data_hash = {
      id: data[0],
      name: data[1],
      email: data[2],
      password: data[3]
    }

    build_user(data_hash)
  end

  def get_user_by_id(id)
    # Input: id[integer]
    # Output: User object
    data = @db.execute(
      "SELECT * FROM users where id = ?", id
      ).flatten
    data_hash = {
      id: data[0],
      name: data[1],
      email: data[2],
      password: data[3]
    }

    build_user(data_hash)
  end

  def get_user_by_email(email)
    # Input: email[string]
    # Output: User object
    # Use this method for signing in

    data = @db.execute(
      "SELECT * FROM users where email = ?", email
      ).flatten

    return false if data.empty?

    data_hash = {
      id: data[0],
      name: data[1],
      email: data[2],
      password: data[3]
    }

    build_user(data_hash)
  end

  def build_checkin(data)
    MakerSpots::Checkin.new(data)
  end

  def create_checkin(data)
    # Input: hash, data location_id[integer], user_id[integer]
    # Output: Checkin object
    # Checkins belong to locations and users. Checked_in is a boolean value, only one checkin per user can be true at any one time. Handle this in a command that runs before creating a new checkin

    # TODO: Validate that checkin with value of 1 does not exist for given user.

    @db.execute(
      "INSERT INTO checkins (
        location_id, user_id, checked_in, created_at)
        VALUES (?,?,?,CURRENT_TIMESTAMP)",
        data[:location_id], data[:user_id], 1
    )

    data = @db.execute(
        "SELECT * FROM checkins where id = last_insert_rowid()"
      ).flatten

    data_hash = {
      id: data[0],
      location_id: data[1],
      user_id: data[2],
      checked_in: data[3],
      created_at: data[4]
    }

    build_checkin(data_hash)
  end

  def get_checkins_by_user(user_id)
    # Input: id[integer]
    # Output: Active checkin object

    # Only select active checkins for a user
    data = @db.execute(
      "SELECT * FROM checkins
      WHERE user_id = ?
      AND checked_in = ?
      ", user_id, 1
    ).flatten

    data_hash = {
      id: data[0],
      location_id: data[1],
      user_id: data[2],
      checked_in: data[3],
      created_at: data[4]
    }

    build_checkin(data_hash)
  end

  def get_checkins_by_location(loc_id)
    # Input: id[integer]
    # Output: Array of Checkin objects
    checkins_holder = []

    # Only select active checkins for a location
    data = @db.execute(
      "SELECT * FROM checkins
      WHERE location_id = ?
      AND checked_in = ?
      ", loc_id, 1
    )

    data.each do |c_data|
      data_hash = {
        id: c_data[0],
        location_id: c_data[1],
        user_id: c_data[2],
        checked_in: c_data[3],
        created_at: c_data[4]
      }

      checkins_holder << build_checkin(data_hash)
    end

    checkins_holder
  end

  def checkout(id)
    # Input: id[integer]
    # Output: Checkin object
    # This method should run on any user checkins that have a checked_in value of 1 before creating a new checkin
    # Only updates checked_in from 1 to 0
    @db.execute(
      "UPDATE checkins
      SET checked_in = ?
      WHERE user_id = ?", 0, id
    )
    data = @db.execute(
      "SELECT * FROM checkins where id = ?", id
    ).flatten

    data_hash = {
      id: data[0],
      location_id: data[1],
      user_id: data[2],
      checked_in: data[3],
      created_at: data[4]
    }

    build_checkin(data_hash)
  end
end

# module MakerSpots
#   def self.db
#     @___db_instance ||= DB.new
#   end
# end
