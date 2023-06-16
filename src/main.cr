require "kemal"
require "db"
require "pg"
require "./db"

db = DB.open CONNECTION do |db|
  get "/films" do |env|
    env.response.content_type = "text/plain" # So browsers don't try to download it
    # There are 100k rows in that table
    films = db.query_all "SELECT id, title, description, release_year FROM films", &.read(Film)
    env.response.print films.to_json
  rescue e
    # Capture errors to prevent the server log from pollution
    puts "Error: #{e.message}"
    env.response.status_code = 500
  end

  # Using this increases the occurance of the issue, making it more likely to reproduce.
  get "/jsonl" do |env|
    env.response.content_type = "text/plain"
    db.query_each "SELECT id, title, description, release_year FROM films" do |rs|
      env.response.puts rs.read(Film).to_json
    end
  rescue e
    puts "Error: #{e.message}"
    env.response.status_code = 500  
  end
  
  Kemal.run 8001
end


