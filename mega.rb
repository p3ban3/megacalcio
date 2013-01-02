require "sinatra"
require  './config'

# squadre = DB.carica "squadre"

enable :sessions


get "/migrate" do
  DataMapper.auto_migrate!
  "db pronto"
end

get "/" do
  erb :index
end

get "/typography" do
  erb :typography
end

get "/squadre" do
  squadre.to_s
end

get "/users/new" do
  erb :users_new
end


post "/users" do
  user = User.new username: params[:username], password: params[:password]
  if user.save
    # loggarlo
    redirect "/"
  else
    erb :users_new
  end
end

get "/login" do
  erb :login
end

post "/login" do
  user = User.first username: params[:username], password: params[:password]
  if user
    session[:user_id] = user.id
    redirect "/"
  else
    erb :login
  end
end

def current_user
  # TODO: ottimizzazione da fare
  User.get session[:user_id]
end

def logged?
  current_user
end


post '/logout' do
  session[:user_id] = nil
  redirect "/"
end

get "/squadre/new" do
  erb :squadre_new
end

get "/squadre/*" do |id|
  @squadra = Squadra.get id
  erb :squadra
end

post '/squadre' do
  squadra = Squadra.new nome: params[:nome], user_id: current_user.id
  squadra.save
  redirect "/squadre/#{squadra.id}"
end

get "/asta" do
  "..."
end

get "/classifica" do
   erb :classifica
end

set(:probability) { |value| condition { rand <= value } }

get '/win_a_car', :probability => 0.1 do
  "You won!"
  erb :win_a_car
end

get '/win_a_car' do
  erb :win_a_car
end

=begin
exit

squadra1 = Squadra.new("p3ban3").hash
squadra2 = Squadra.new("Can3x").hash

puts Dado.new(squadra1, squadra2).risultato
puts "---"
puts squadra1
puts squadra2

squadre = [squadra1, squadra2]
DB.salva "squadre", squadre
=end