require 'csv'

require "pg"

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end


result = db_connection {|conn| conn.exec("SELECT * FROM product WHERE product_name = 'Chimp Glass'")}

# result.each do |res|
#   puts res['id']
# end
puts result[0]['id']






# "SELECT * FROM product WHERE product_name = 'Chimp Glass'"
