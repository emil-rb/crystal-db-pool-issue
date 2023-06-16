require "db"
require "pg"
require "./db"

alias TChannel = Channel(Int32)
alias TDone = Channel(Bool)

COUNT = 200

def start_consumer(channel : TChannel, done : TDone)
  spawn do
    indeces = Set(Int32).new
    loop do
      indeces << channel.receive
      puts "Received size=#{indeces.size}"
      break if indeces.size == COUNT
    end
    done.send true
  end
end

def start_producers(channel : TChannel)
  db = DB.open CONNECTION do |db|
    COUNT.times do |index|
      spawn do 
        puts "Sending #{index}"
        _films = db.query_all "SELECT id, title, description, release_year FROM films", &.read(Film)
      rescue ex
        puts "Error: #{ex.message}"
      ensure
        channel.send index
      end
    end
  end
end


channel = TChannel.new
done = TDone.new
start_consumer(channel, done)
start_producers(channel)

done.receive
