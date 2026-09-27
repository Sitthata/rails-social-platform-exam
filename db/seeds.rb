if Rails.env.development?
  %w[first@example.com jane@example.com].each do |email|
    User.find_or_create_by!(email: email) do |user|
      user.password = "password123"
      user.password_confirmation = "password123"
    end
  end
end
