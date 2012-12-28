
require "sinatra"
require_relative "giocatore"
require_relative "squadra"
require_relative "dado"
require_relative "db"

# squadre = DB.carica "squadre"

enable :sessions


SQUADRE = DB.carica "squadre"

def salva_squadra(squadra)
  SQUADRE.push squadra
  DB.salva :squadre, SQUADRE
end

get "/" do
  erb :index
end

get "/squadre" do
  squadre.to_s
end

get "/login" do
  erb :login
end

post "/login" do
  session[:user] = params[:username]
  redirect "/"
end

post '/logout' do
  session[:user] = nil
  redirect "/"
end

get "/squadre/new" do
  erb :squadre_new
end

get "/squadre/*" do |nome|
  @nome = nome
  # carica squadra (nome)
  erb :squadra
end

post '/squadre' do
  squadra = Squadra.new params[:nome]
  salva_squadra squadra
  redirect "/squadre/#{squadra.nome}"
end

get "/asta" do
  "..."
end

get "/classifica" do
   erb :classifica
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