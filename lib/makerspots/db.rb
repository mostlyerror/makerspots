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
  end

  def build_location(data)
    MakerSpots::Location.new(data)
  end

  def create_location(data)
    # Input: hash, data, name, description, phone address required
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

  def build_user(data)
    MakerSpots::User.new(data)
  end

  def create_user(data)
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
end

module MakerSpots
  def self.db
    @___db_instance ||= DB.new
  end
end
