class User < Hanami::Entity
  def screenshot_path
    "#{ENV.fetch('HOST')}/screenshots/#{id}_screenshot.png"
  end
end
