require "db"

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