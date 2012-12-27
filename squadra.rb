require_relative "giocatore"

class Squadra 
  
  def initialize(nome)
    squadra = { nome: nome, giocatori: gen_giocatori  }
    squadra[:stats] = punteggio_squadra(squadra)
    @squadra = squadra
  end

  def nome
    @squadra[:nome]
  end

  def hash
    @squadra
  end

  def gen_giocatori
    giocatori = []
    for num in 0..10 
      giocatori[num] = Giocatore.new.hash 
    end
    giocatori
  end

  def punteggio_squadra(squadra)
    punteggio = 0
    for giocatore in squadra[:giocatori]
      punteggio = punteggio + giocatore[:stats]
    end
    punteggio / 11
  end

end