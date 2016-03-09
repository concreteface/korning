require 'csv'
require 'pg'

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
    ensure
    connection.close
  end
end

contents = []
result = db_connection {|conn| conn.exec("SELECT name_email FROM employee")}
result.each do |res|
  contents << res['name_email']
end
 # puts contents[0]
included = false
CSV.read('sales.csv').each do |array|
  array.each do |data|
  if data.include?("#{contents[0]}")
    included = true
  end
  end
end
puts included
