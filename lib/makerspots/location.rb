class MakerSpots::Location
  attr_reader :id, :name, :description, :phone, :address

  def initialize(params)
    @id = params[:id]
    @name = params[:name]
    @description = params[:description]
    @phone = params[:phone]
    @address = params[:address]
  end
end
