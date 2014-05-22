class MakerSpots::User
  attr_reader :id, :name, :email, :password

  def initialize(params)
    @id = params[:id]
    @name = params[:name]
    @email = params[:email]
    @password = params[:password]
  end
end
