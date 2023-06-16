require "kemal"
require "db"
require "pg"
require "./db"

CONNECTION = "postgres://postgres@localhost/crystal_load_test?initial_pool_size=5&max_pool_size=5&max_idle_pool_size=5"

db = DB.open CONNECTION do |db|
  get "/films" do |env|
    env.response.content_type = "text/plain"
    films = db.query_all "SELECT id, title, description, release_year FROM films", &.read(Film)
    env.response.print films.to_json
  rescue e
    puts "Error: #{e.message}"
    env.response.status_code = 500
  end

  get "/jsonl" do |env|
    env.response.content_type = "text/plain" # So browsers don't try to download it
    db.query_each "SELECT id, title, description, release_year FROM films" do |rs|
      env.response.puts rs.read(Film).to_json
    end
  rescue e
    puts "Error: #{e.message}"
    env.response.status_code = 500  
  end
  
  Kemal.run 8001
end


