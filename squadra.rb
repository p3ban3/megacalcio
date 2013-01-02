require_relative "giocatore"

class Squadra 
  include DataMapper::Resource
 
  property :id,       Serial
  property :nome,     String
  property :stats,    Integer
  property :giocatori,    Json
  property :user_id, Integer
  #attr_reader :giocatori

  before :create do
    self.giocatori = self.gen_giocatori
    self.stats = self.punteggio_squadra
  end

  def gen_giocatori
    giocatori = []
    for num in 0..10 
      giocatori[num] = Giocatore.new.hash 
    end
    giocatori
  end

  def punteggio_squadra
    punteggio = 0
    for giocatore in giocatori
      punteggio = punteggio + giocatore[:stats]
    end
    punteggio / 11
  end

end