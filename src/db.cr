require "db"

class Film
    include JSON::Serializable
  
    DB.mapping({
      id: Int32,
      title: String,
      description: String,
      release_year: Int32
    })
  end