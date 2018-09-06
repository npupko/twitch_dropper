module Web::Controllers::Users
  class Update
    include Web::Action

    def call(params)
      UserRepository.new.update(params[:id], params[:user])
      Workers::WatchWorker.perform_async(user.id) if worker_enabled?
      redirect_to routes.root_path
    end

    private

    def user
      UserRepository.new.find_by_id params[:id]
    end

    def worker_enabled?
      params[:user][:worker_status].eql? 'true'
    end
  end
end
