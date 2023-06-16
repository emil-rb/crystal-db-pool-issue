def mem
    channel = Channel(Int32).new
    spawn do
      counter = 0
      loop do
        channel.receive
        counter += 1
        puts "Received #{counter}"
      end
    end
  
    db = DB.open CONNECTION do |db|
      100.times do |index|
        spawn do 
          puts "Sending #{index}"
          _films = db.query_all "SELECT id, title, description, release_year FROM films", &.read(Film)
          channel.send index
        end
      end
    end
  
    Fiber.yield
    sleep
  end
  
  mem
  