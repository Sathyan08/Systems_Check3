require "sinatra"

require "sinatra/reloader"

require "pg"

def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')

    yield(connection)

  ensure
    connection.close
  end
end



get '/recipes' do

  db_connection do |conn|
    @recipes = conn.exec('SELECT * FROM recipes')
  end

  erb :recipes

end

get '/recipes/:id' do

  @id = params[:id]

  db_connection do |conn|
      @recipe = conn.exec('SELECT * FROM recipes WHERE id = $1', [@id])
      @ingredients = conn.exec('SELECT * FROM ingredients WHERE recipe_id = $1', [@id])
  end

  erb :show
end
