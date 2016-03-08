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
#
# # sales: sale_date, sale_amount, units_sold, invoice_num
#
#
# CSV.foreach('sales.csv', headers:true) do |row|
#   db_connection {|conn| conn.exec_params("INSERT INTO sales (employee_name, customer_acct_number, product_name, sale_date, sale_amount, units_sold, invoice_num, invoice_freq) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)", [row['employee'],row['customer_and_account_no'], row['product_name'], row['sale_date'], row['sale_amount'], row['units_sold'], row['invoice_no'], row['invoice_frequency']] )}
# end

result = db_connection {|conn| conn.exec("SELECT product_name FROM product;")}
product_contents = []
result.each do |content|
product_contents << content
end

puts product_contents
