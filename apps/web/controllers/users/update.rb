module Web::Controllers::Users
  class Update
    include Web::Action

    def call(params)
      UserRepository.new.update(params[:id], params[:user])
      WatchWorker.perform_async(user.id) if params[:worker_status].eql? true
      redirect_to routes.root_path
    end
  end
end
