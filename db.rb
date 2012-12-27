class DB
  
  def self.salva(nome, contenuto)
    File.open("db/#{nome}.ruby", "w") do |file|
      file.write contenuto
    end
  end

  def self.carica(nome)
    eval File.read("db/#{nome}.ruby")
  end

end