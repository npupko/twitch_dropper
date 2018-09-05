class WatchWorker
  include Sidekiq::Worker

  def perform(id)
    Services::Watcher.new.call(user: user(id))
  end

  private

  def user(id)
    UserRepository.new.find(id)
  end
end
