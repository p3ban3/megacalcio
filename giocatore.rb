NOMI = ["pino", "paolo", "pietro", "giovanni", "francesco", "alessio", "alex", "glauco" ]
COGNOMI = ["giobbe", "grunu", "frusta", "cavallo", "cane", "torre", "porcus", "canex", "pebans" ]


class Giocatore

  def initialize
    nome = NOMI.shuffle.first
    cognome = COGNOMI.shuffle.first
    @giocatore = { nome: "#{nome} #{cognome}", stats: rand(40..100) }
  end

  def hash
    @giocatore  
  end

end