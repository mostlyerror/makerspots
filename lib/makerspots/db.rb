require 'pry'
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
    ).flatten!

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
    ).flatten!

    data_hash = {
      id: data[0],
      name: data[1],
      description: data[2],
      phone: data[3],
      address: data[4]
    }

    build_location(data_hash)
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
    ).flatten!

    data_hash = {
      id: data[0],
      name: data[1],
      email: data[2],
      password: data[3]
    }

    build_user(data_hash)
  end

  def get_user(id)
    # Input: id[integer]
    # Output: User object

    data = @db.execute(
      "SELECT * FROM users where id = ?", id
      ).flatten!

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

    @db.execute(
      "INSERT INTO checkins (
        location_id, user_id, checked_in, created_at)
        VALUES (?,?,?,CURRENT_TIMESTAMP)",
        data[:location_id], data[:user_id], 1
    )

    data = @db.execute(
        "SELECT * FROM checkins where id = last_insert_rowid()"
      ).flatten!

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
