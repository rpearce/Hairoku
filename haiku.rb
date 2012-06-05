require './includes'

class Haiku
  include MongoMapper::Document

  key :created_at, Time
  key :text, String
  key :id, Time
end