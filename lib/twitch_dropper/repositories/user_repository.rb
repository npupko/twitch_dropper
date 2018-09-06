class UserRepository < Hanami::Repository
  def find_by_id(id)
    root.where(id: id).one
  end
end
