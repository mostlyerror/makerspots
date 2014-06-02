class MakerSpots::CheckOutUser

  def self.run(user_id)
    checked_out = MakerSpots.db.checkout(user_id)
    {
      success?: true,
      checked_out: checked_out,
      message: "Checked out successfully"
    }
  end
end
