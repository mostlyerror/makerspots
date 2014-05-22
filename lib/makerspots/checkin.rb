class MakerSpots::Checkin
  attr_reader :id, :location_id, :user_id, :checked_in, :created_at
  def initialize(params)
    @id = params[:id]
    @location_id = params[:location_id]
    @user_id = params[:user_id]
    @checked_in = params[:checked_in]
    @created_at = params[:created_at]
  end
end
