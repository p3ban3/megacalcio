#!/usr/bin/env ruby

#####################################################################
#
# morra.rb (Gioco di Morra per Ruby)
$prog = "morra.rb - ver 1.0"
#
#
# 22/11/2007
$author = " edited by Invisigoth <njprincess_autobot@yahoo.it>"
#
$hstr = "\n*** " + $prog + "\n***" + $author + "\n\nEnjoy the Sciuogliocane's favourite game!!!!"
#
######################################################################
require 'socket'

def globalM_Authors
	puts $hstr
	begin
		puts "Premere invio per uscire..."
		$stdin.readline
	rescue Interrupt
	end
end

def funnyWait(s=0.4)
	sleep s
end

class Mano
	NIL_VALUE = 0
	attr_accessor	:value
	def initialize(value = NIL_VALUE)
		self.value = value
	end
	def Mano.NIL_VALUE
		NIL_VALUE
	end
	def value=(value)
		if value.nil? then
			@value = nil
			return false
		end
		value = value.to_i
		if( ((value >= 1) && (value <= 5)) || (value == NIL_VALUE ) ) then
			@value = value
			return true
		else
			@value = nil
			return false
		end
	end
	def value
		@value
	end
	def nil?
		@value.nil?
	end
	def to_s
		@value.to_s
	end
end

class Voce
	NIL_VALUE = 0
	attr_accessor	:value
	def initialize(value = NIL_VALUE)
		self.value = value
	end
	def Voce.NIL_VALUE
		NIL_VALUE
	end
	def value=(value)
		if value.nil? then
			@value = nil
			return false
		end
		value = value.to_i
		if( ((value >= 2) && (value <= 10)) || (value == NIL_VALUE) ) then
			@value = value
			return true
		else
			@value = nil
			return false
		end
	end
	def nil?
		@value.nil?
	end
	def to_s
		@value.to_s
	end
end

class Giocata
	SEPARATOR = "|"
	attr_accessor	:mano, :voce, :manoStr, :voceStr
	attr_accessor	:comment
	def initialize(mano = Mano.NIL_VALUE, voce = Voce.NIL_VALUE)
		@mano = Mano.new mano
		@voce = Voce.new voce
		@comment = String.new
	end
	def to_s
		@mano.to_s + SEPARATOR + @voce.to_s + SEPARATOR + @comment
	end
	def from_s(str)
		regexp1 = Regexp.new "(\\w+)\\|(\\w+)\\|"
		regexp2 = Regexp.new "(\\w+)\\|(\\w+)\\|(.+)"
		if(regexp2.match(str)) then
			@mano.value = $1
			@voce.value = $2
			@comment = $3
			return true
		elsif(regexp1.match(str)) then
			@mano.value = $1
			@voce.value = $2
			@comment = ""
			return true
		else
			return false
		end
	end
	def is_valid?
		if(@voce.value > @mano.value) then
			return true
		else
			return false
		end
	end
	def nil?
		ret = @mano.nil? || @voce.nil? || @comment.nil?
		return ret
	end
	def comment=(str)
		@comment = str unless str.nil?
	end
	def comment?
		@comment.nil? && (@comment == "")
	end
	def <=>(g2)
		if(g2.class == Giocata) then
			if(@voce.value == g2.voce.value) then
				return 0
			elsif(@voce.value == (@mano.value + g2.mano.value)) then
				return 1
			elsif(g2.voce.value == (@mano.value + g2.mano.value)) then
				return 2
			else
				return 3
			end
		else
			return -1
		end
	end
end

class ManoTab
	def initialize
		@ltab = []
		@DEF_TAB = {"0" => 1, "1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5}
		@ltab << @DEF_TAB
	end
	def addTab(tab)
		@ltab << tab
	end
	def getVal(str)
		@ltab.each do |t|
			return t[str] if(t.has_key? str)
		end
		return nil
	end
	def list
		retStr = ""
		@ltab.each { |a| a.each {|i| retStr += i[0].to_s + " => " + i[1].to_s + "\n" } }
		return retStr
	end
end

class VoceTab
	def initialize
		@ltab = []
		@DEF_TAB = {"2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8, "9" => 9, "10" => 10, "morra" => 10}
		@ltab << @DEF_TAB
	end
	def addTab(tab)
		@ltab << tab
	end
	def getVal(str)
		@ltab.each do |t|
			return t[str] if(t.has_key?(str))
		end
		return nil
	end
	def list
		retStr = ""
		@ltab.each { |a| a.each {|i| retStr += i[0].to_s + " => " + i[1].to_s + "\n" } }
		return retStr
	end
end

class GiocataTab
	attr_accessor	:manoTab, :voceTab

	def initialize
		@manoTab = ManoTab.new
		@voceTab = VoceTab.new
	end
	def convert(mano, voce)
		retGiocata = Giocata.new
		retGiocata.mano.value = @manoTab.getVal(mano)
		retGiocata.voce.value = @voceTab.getVal(voce)
		if retGiocata.nil?
			return nil
		else
			return retGiocata
		end
	end
end

class Player
	attr_accessor	:nome, :punti, :giocata, :gTab, :channel, :brain

	def initialize(nome = "")
		@nome = nome
		@punti = 0
		@giocata = Giocata.new
		@gTab = GiocataTab.new
		#@ccom = CCom.new
	end
	def incPunti
		@punti += 1
	end
	def resetPunti
		@punti = 0
	end
	def gioca(giocata)
		@giocata = giocata
	end
end




class GameRepository
	attr_accessor	:mePlayer, :avvPlayer, :meDone, :avvDone, :conn, :channel
	def initialize
		@mePlayer = Player.new
		@avvPlayer = Player.new
		@meDone = @avvDone = false
	end
end

class GameController
	SEPARATOR_TAG = "-----------------------------------------------"
	#attr_accessor	:gRep, :gTab

	def initialize(gRep, gTab)
		@@gRep = gRep
		@gTab = gTab
	end
	def procGame
		loop do
			while(true) do
				ret = getMeGiocata
				break if(ret == 0)
				puts "comando errato. Digita \"help\"." if (ret == -1)
				GameController.closeController if(ret == 1)
			end
			printGiocata @@gRep.mePlayer
			puts "Attendo giocata avversaria.." if(!@@gRep.avvDone)
			ret = getAvvGiocata
			GameController.closeController if(ret == 1)
	###
		funnyWait
	###

			printGiocata @@gRep.avvPlayer
#			if(@@gRep.meDone && @@gRep.avvDone) then
				esito = @@gRep.mePlayer.giocata <=> @@gRep.avvPlayer.giocata
				@@gRep.meDone = @@gRep.avvDone = false
				procEsito esito
#			end
			printStatus
			puts SEPARATOR_TAG
		end
	end

	private
	def getMeGiocata
		print @@gRep.mePlayer.nome + ": "
		str = $stdin.readline.chomp!
		regexp1 = Regexp.new "(\\w+)\\s+(.+)"
		regexp2 = Regexp.new "(\\w+)\\s+(\\w+)\\s+(.+)"
		ret = procCmd(str)
		return ret if ret != 0
#		return -1 if str.split.length > 3
		if( (regexp2.match str) ) then
			g = @gTab.convert($1, $2)
			if(g.nil?) then
				return -1
			end
			g.comment = $3
			#puts g.inspect
			@@gRep.mePlayer.giocata = g
			@@gRep.channel.send g.to_s
			@@gRep.meDone = true
			return 0
		elsif( (regexp1.match str) )then
			g = @gTab.convert($1, $2)
			if(g.nil?) then
				return -1
			end
			g.comment = ""
			#puts g.inspect + "\n" + g.comment
			@@gRep.mePlayer.giocata = g
			@@gRep.channel.send g.to_s
			@@gRep.meDone = true
			return 0
		else
			return -1
		end

	end
	def getAvvGiocata
		msg = @@gRep.channel.receive.chomp!
		if(!@@gRep.avvDone) then
			if(@@gRep.avvPlayer.giocata.from_s msg) then
				@@gRep.avvDone = true
				return 0
			elsif(msg =~/exit/)
				puts @@gRep.avvPlayer.nome + " ha chiuso la partita."
				return 1
			end
		end
	end
	def procCmd(cmd)
		cmd_down = cmd.downcase
		if cmd_down == "exit" then
			@@gRep.channel.send cmd_down
			return 1
		elsif cmd_down == "reset"
			@@gRep.mePlayer.resetPunti
			@@gRep.avvPlayer.resetPunti
			puts "Reset dei punti"
			printStatus
			return 2
		elsif cmd_down =~ /add\s+(voce|mano)\s+(\w+)\s+(\d+)/
			h = { $2 => $3.to_i }
			if $1 =="voce" then
				@gTab.voceTab.addTab h
			else
				@gTab.manoTab.addTab h
			end
			puts "Aggiunta corrispondenza #$2 -> #$3 alla tabella della #$1"
			return 2
		elsif cmd_down == "list" then
			puts "Tabella Voce:"
			puts @gTab.voceTab.list
			puts "Tabella Mano:"
			puts @gTab.manoTab.list
			return 2
		elsif ( (cmd_down == "help") || (cmd_down == "?") )
			puts "Lista comandi:"
			puts " MANO VOCE commento_eventuale -> manda la giocata"
			puts " exit -> esce dal gioco"
			puts " reset -> resetta il punteggio dei giocatori"
			puts " status -> visualizza i punteggi"
			puts " help -> ...indovina?"
			puts " about -> informazioni sul programma e sull'autore"
			return 2
		elsif cmd_down =~ /about/
			globalM_Authors
			return 2
		elsif cmd_down == "status"
			printStatus
			return 2
		else
			return 0
		end
	end
	def procEsito(esito)
		closeController("Errore imprevisto") if esito == -1
		if(esito == 3) then
			puts "Non ha vinto nessuno"
		elsif(esito == 0) then
			puts "Giocata patta!!"
		elsif(esito == 1) then
			puts "Vince " + @@gRep.mePlayer.nome + "!"
			@@gRep.mePlayer.incPunti
		elsif(esito == 2) then
			puts "Vince " + @@gRep.avvPlayer.nome + "!"
			@@gRep.avvPlayer.incPunti
		end
	end

	def printStatus
		print "\n***  " + @@gRep.mePlayer.nome + " " + @@gRep.mePlayer.punti.to_s
		if(@@gRep.mePlayer.punti == 1) then
			print " (ain)"
		elsif(@@gRep.mePlayer.punti == 2) then
			print " (zvain)"
		end
		print " - " + @@gRep.avvPlayer.punti.to_s
		if(@@gRep.avvPlayer.punti == 1) then
			print " (ain)"
		elsif(@@gRep.avvPlayer.punti == 2) then
			print " (zvain)"
		end
		print " " + @@gRep.avvPlayer.nome + "  ***\n"
	end
	def printGiocata(player)
		print player.nome
		if !player.giocata.mano.nil? then
			print " ha giocato di mano " + player.giocata.mano.to_s
		else
			print " non gioca di mano"
		end
		if !player.giocata.voce.nil? then
			print " e dice " + player.giocata.voce.to_s
		else
			print " e non dice niente"
		end
		if !player.giocata.comment? then
			print " [commento: \"" + player.giocata.comment + "\"]\n"
		end
	end
	def GameController.closeController(str="")
		puts str
		globalM_Authors
		@@gRep.conn.close
		exit -1
	end
end

class StartController
	def initialize
		@gRep = GameRepository.new
		@cRep = ConnRepository.new
	end
	
	def gameRepository
		@gRep
	end
	private
	def connect
		@gRep.conn = Connection.new @cRep
		@gRep.conn.open
	end

end

def mainLoop
	startController = StartController.new
	gameController = GameController.new startController.gameRepository, GiocataTab.new

	startController.procStart
	gameController.procGame
end

begin
	mainLoop
rescue Interrupt => i
	puts "\n-----------------------------"
	puts "Catturato interrupt..uscita."
	globalM_Authors
end
