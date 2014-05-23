class MakerSpots::CheckOutUser

  def self.run(user_id)

    MakerSpots.db.checkout(user_id)
    {
      success?: true,
      message: "Checked out successfully"
    }
  end
end
