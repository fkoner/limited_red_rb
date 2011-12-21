def setup_fixtures(connection)
  doc = {:username => 'josephwilk', :email => 'j@o.e', :api_key => '123'}
  connection.db('limited_red')['mm_users'].insert(doc)
  docs = [{:project_id => 'cuke_internal_tests', :user_id => 'josephwilk'},
    {:project_id => 'build_1', :user_id => 'josephwilk'},
  {:project_id => 'build_2', :user_id => 'josephwilk'}]
  docs.each { |doc| connection.db('limited_red')['limited_red.data.projects'].insert(doc) }
end

Before do
  m = Mongo::Connection.new('localhost', Mongo::Connection::DEFAULT_PORT)
  m.drop_database('limited_red')
  setup_fixtures(m)
end
