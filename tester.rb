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


puts result[0]['id']
#{Finder.new(row["employee"], 'employee', 'name_email').find_id}
#{Finder.new(row["customer_and_account_no"], 'customer_acct_num', 'name_number').find_id}
#{Finder.new(row["product_name"], 'product', 'product_name').find_id}
#{Finder.new(row["invoice_frequency"], 'frequency', 'invoice_frequency').find_id}






# "SELECT * FROM product WHERE product_name = 'Chimp Glass'"
