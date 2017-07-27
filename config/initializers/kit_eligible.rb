Rails.application.config.to_prepare do
  User.include KitEligible
end
