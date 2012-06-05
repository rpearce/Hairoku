require 'sinatra'
require './includes'

class PostHaiku
  def initialize
    MongoMapper.connection = Mongo::Connection.new('staff.mongohq.com', 10071)
    MongoMapper.database = 'hairoku'
    MongoMapper.database.authenticate(USERNAME, PASSWORD)
    Haiku.ensure_index(:id, :unique => true)
    Haiku.ensure_index(:created_at)
  end

  def post_haiku(text)
    Haiku.create({
      :created_at => Date.today,
      :text => text
    })
  end
end

get '/' do
  haml :index
end

post '/post_haiku/?' do
  puts 'HELLOOOO'
  puts params[:text].inspect
  haiku = PostHaiku.new
  haiku.post_haiku(params[:text])
end