class MakerSpots::Location
  attr_reader :id, :name, :description, :phone, :address

  def initialize(params)
    @id = params[:id]
    @name = params[:name]
    @description = params[:description]
    @phone = params[:phone]
    @address = params[:address]
  end

  # def phone
  #   @phone = @phone.to_s
  #   @phone = @phone.split("")
  #   "(#{@phone[0..2]}) #{@phone[3..6]}-#{@phone[7..-1]}"
  # end

end
