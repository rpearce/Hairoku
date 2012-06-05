require 'sinatra'
require './includes'

class PostHaiku
  def initialize
    MongoMapper.connection = Mongo::Connection.new('staff.mongohq.com', 10071)
    MongoMapper.database = 'hairoku'
    MongoMapper.database.authenticate(USERNAME, PASSWORD)
    # Haiku.ensure_index(:text, unique: true)
  end

  def post_haiku(text)
    Haiku.create({
      created_at: DateTime.now,
      text: text,
      id: DateTime.now
    })
  end
end

get '/' do
  haml :index
end

post '/post_haiku/?' do
  puts 'JALO'
  puts request.inspect

  hash = JSON.parse request.body.read
  haiku = PostHaiku.new

  haiku.post_haiku(hash['text'])
end