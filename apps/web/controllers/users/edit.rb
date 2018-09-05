module Web::Controllers::Users
  class Edit
    include Web::Action
    expose :user

    def call(params)
      @user = UserRepository.new.find(params[:id])
    end
  end
end
