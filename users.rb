class User
  include DataMapper::Resource

  property :id, Serial
  property :username, String, unique: true
  property :password, String

  def squadra
    Squadra.first user_id: id
  end

end