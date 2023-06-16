require "kemal"
require "db"
require "pg"

CONNECTION = "postgres://postgres@localhost/crystal_load_test?initial_pool_size=5&max_pool_size=5&max_idle_pool_size=5"

class Film
  include JSON::Serializable

  DB.mapping({
    id: Int32,
    title: String,
    description: String,
    release_year: Int32
  })
end

db = DB.open CONNECTION do |db|
  get "/films" do |env|
    env.response.content_type = "application/json"
    films = db.query_all "SELECT id, title, description, release_year FROM films", &.read(Film)
    env.response.print films.to_json
  rescue e
    puts "Error: #{e.message}"
    env.response.status_code = 500
  end
  
  Kemal.run 8001
end



