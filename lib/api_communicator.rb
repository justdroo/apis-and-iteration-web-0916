require 'rest-client'
require 'json'

def get_character_movies_from_api(character)
  #make the web request
  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  character_hash = JSON.parse(all_characters).fetch("results")


  # iterate ove the character hash to find the collection of `films` for the given
  #   `character`
  films = character_hash.each_with_object([]) do |single_character, obj_arr|
    #TRY WITH SELECT

    if single_character.fetch("name").downcase == character.downcase
      obj_arr << single_character.fetch("films")
    end
  end

  films.flatten!

  # collect those film API urls, make a web request to each URL to get the info
  #  for that film
  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film
  films_hash = films.each_with_object([]) do |film_url, obj_arr|
    film_raw_text = RestClient.get(film_url)
    film_hash = JSON.parse(film_raw_text)
    obj_arr << film_hash
  end
  # this collection will be the argument given to `parse_character_movies`
end


#  and that method will do some nice presentation stuff: puts out a list
#  of movies by title. play around with puts out other info about a given film.
def parse_character_movies(films_hash)
  films_hash.each_with_object([]) do |film, obj_arr|
    obj_arr << film.fetch("title")
  end


end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  parsed_list = parse_character_movies(films_hash)

  parsed_list.each_with_index do |film_name, index|
    puts "#{index + 1}. #{film_name}"
  end
end



## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
