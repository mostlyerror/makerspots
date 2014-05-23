require 'pry'
class MakerSpots::DB

  def initialize
    # Database method
    @db = PG.connect( dbname: 'makerspotsdb' )
    @db.exec(
      "CREATE TABLE if not exists locations(
      id serial,
      name text NOT NULL,
      description text NOT NULL,
      phone text,
      address text NOT NULL,
      PRIMARY KEY (id)
      )"
      )

    @db.exec(
      "CREATE TABLE if not exists users(
      id serial,
      name text NOT NULL,
      email text NOT NULL UNIQUE,
      password text NOT NULL,
      PRIMARY KEY (id)
      )"
    )

    @db.exec(
      "CREATE TABLE if not exists checkins(
        id serial,
        location_id integer,
        user_id integer,
        checked_in boolean,
        created_at timestamp,
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
    data =
      @db.exec_params(
        "INSERT INTO locations (name, description, phone, address)
        VALUES ($1,$2,$3,$4) RETURNING id, name, description, phone, address",
        [data[:name], data[:description], data[:phone], data[:address]]
      )
    data_hash = {
      id: data[0]['id'],
      name: data[0]['name'],
      description: data[0]['description'],
      phone: data[0]['phone'],
      address: data[0]['address']
    }

    build_location(data_hash)
  end

  def get_location(id)
    # Input: id[integer]
    # Output: Location object

    data = @db.exec_params(
      "SELECT * FROM locations
      WHERE id = $1", [id]
    )

    data_hash = {
      id: data[0]['id'],
      name: data[0]['name'],
      description: data[0]['description'],
      phone: data[0]['phone'],
      address: data[0]['address']
    }

    build_location(data_hash)
  end

  def get_all_locations
    # Output: Array of Location objects. Ascending order by id

    locations_holder = []
    data = @db.exec(
      "SELECT * FROM locations"
    )

    # Data is an array of location data in hash format
    data.each do |location|
      data_hash = {
        id: location['id'],
        name: location['name'],
        description: location['description'],
        phone: location['phone'],
        address: location['address']
      }
      locations_holder << build_location(data_hash)
    end

    locations_holder
  end

  def build_user(data)
    MakerSpots::User.new(data)
  end

  def create_user(data)
    # Input: hash, data name[string], email[string], password[string]. All required
    # Output: User object

    @db.exec(
      "INSERT INTO users (name, email, password)
      VALUES (?,?,?)",
      data[:name], data[:email], data[:password]
    )

    data = @db.exec(
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

    data = @db.exec(
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

    data = @db.exec(
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

    @db.exec(
      "INSERT INTO checkins (
        location_id, user_id, checked_in, created_at)
        VALUES (?,?,?,CURRENT_TIMESTAMP)",
        data[:location_id], data[:user_id], 1
    )

    data = @db.exec(
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
    data = @db.exec(
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
    data = @db.exec(
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

    @db.exec(
      "UPDATE checkins
      SET checked_in = ?
      WHERE id = ?
      AND checked_in = ?", 0, id, 1
    )

    data = @db.exec(
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

module MakerSpots
  def self.db
    @___db_instance ||= DB.new
  end
end
