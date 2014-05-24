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
    data = @db.exec_params(
      "INSERT INTO users (name, email, password)
      VALUES ($1,$2,$3) RETURNING id, name, email, password",
      [data[:name], data[:email], data[:password]]
    )

    data_hash = {
      id: data[0]['id'],
      name: data[0]['name'],
      email: data[0]['email'],
      password: data[0]['password']
    }

    build_user(data_hash)
  end

  def get_user_by_id(id)
    # Input: id[integer]
    # Output: User object

    data = @db.exec(
      "SELECT * FROM users where id = $1", [id]
      )

    data_hash = {
      id: data[0]['id'],
      name: data[0]['name'],
      email: data[0]['email'],
      password: data[0]['password']
    }

    build_user(data_hash)
  end

  def get_user_by_email(email)
    # Input: email[string]
    # Output: User object
    # Use this method for signing in

    data = @db.exec(
      "SELECT * FROM users where email = $1", [email]
      )

    return false if data[0].empty?

    data_hash = {
      id: data[0]['id'],
      name: data[0]['name'],
      email: data[0]['email'],
      password: data[0]['password']
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
    data = @db.exec_params(
      "INSERT INTO checkins (
        location_id, user_id, checked_in, created_at)
        VALUES ($1,$2,$3,CURRENT_TIMESTAMP)
        RETURNING id, location_id, user_id, checked_in, created_at",
        [data[:location_id], data[:user_id], 1]
    )

    data_hash = {
      id: data[0]['id'],
      location_id: data[0]['location_id'],
      user_id: data[0]['user_id'],
      checked_in: data[0]['checked_in'],
      created_at: data[0]['created_at']
    }

    build_checkin(data_hash)
  end

  def get_checkins_by_user(user_id)
    # Input: id[integer]
    # Output: Active checkin object

    # Only select active checkins for a user
    data = @db.exec_params(
      "SELECT * FROM checkins
      WHERE user_id = $1
      AND checked_in = $2
      ", [user_id, 1]
    )

    data_hash = {
      id: data[0]['id'],
      location_id: data[0]['location_id'],
      user_id: data[0]['user_id'],
      checked_in: data[0]['checked_in'],
      created_at: data[0]['created_at']
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
      WHERE location_id = $1
      AND checked_in = $2
      ", [loc_id, 't']
    )
    data.each do |checkin|
      data_hash = {
        id: checkin['id'],
        location_id: checkin['location_id'],
        user_id: checkin['user_id'],
        checked_in: checkin['checked_in'],
        created_at: checkin['created_at']
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

    @db.exec_params(
      "UPDATE checkins
      SET checked_in = $1
      WHERE id = $2
      AND checked_in = $3", [0, id, 1]
    )

    data = @db.exec_params(
      "SELECT * FROM checkins where id = $1", [id]
    )

    data_hash = {
      id: data[0]['id'],
      location_id: data[0]['location_id'],
      user_id: data[0]['user_id'],
      checked_in: data[0]['checked_in'],
      created_at: data[0]['created_at']
    }

    build_checkin(data_hash)
  end
end

module MakerSpots
  def self.db
    @___db_instance ||= DB.new
  end
end
