Before do
  m = Mongo::Connection.new('localhost',Mongo::Connection::DEFAULT_PORT)
  m.drop_database('cuke_max')
end