class Dado

  RANGE_PAREGGIO = 10
   
  def initialize(squadra1, squadra2)
    squadre = [squadra1, squadra2]
    @squadra1 = squadra1 
    @squadra2 = squadra2

    @squadra1[:punteggio] = lancio(@squadra1)
    @squadra2[:punteggio] = lancio(@squadra2)

    squadre.sort!{ |sq1, sq2| sq1[:punteggio] <=> sq2[:punteggio]  }
   
    calcola_gol(squadre[1], squadre[0])

    @vincitrice = nil
  end 

  def calcola_gol(squadra1, squadra2)
    if punteggio_simile(squadra1, squadra2)
      squadra1[:gol] = squadra2[:gol] = rand(4) # pareggio
    else
      diff_punteggi = squadra1[:punteggio] - squadra2[:punteggio]
      gol_base = rand(2)
      gol_diff_punteggi = 1 + (diff_punteggi/110)*3 # da rivedere
      squadra1[:gol] = gol_base + gol_diff_punteggi
      squadra2[:gol] = gol_base
    end
  end

  def punteggio_simile(squadra1, squadra2)
    squadra1[:punteggio]-RANGE_PAREGGIO < squadra2[:punteggio]
  end

  def lancio(squadra)
    squadra[:stats] + rand(50) # 40..150
  end 
   
  def risultato
    {
      squadra1: {
        punteggio: @squadra1[:punteggio],
        gol: @squadra1[:gol]
      },
      squadra2: {
        punteggio: @squadra2[:punteggio],
        gol: @squadra2[:gol]
      },
      vincitrice: @vincitrice
    }
  end 
   
end 