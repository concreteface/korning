# Use this file to import the sales information into the
# the database.

require "pg"
require 'csv'
require 'pry'
require_relative 'id_finder'

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
    ensure
    connection.close
  end
end

product_contents = []
CSV.foreach('sales.csv', headers:true) do |row|
  if !product_contents.include?(row['product_name'])
    db_connection {|conn| conn.exec_params("INSERT INTO product (product_name) VALUES ($1)", [row['product_name']] )}
  end
  result = db_connection {|conn| conn.exec("SELECT product_name FROM product;")}
  result.each do |content|
    product_contents << content['product_name']
  end
end

product_contents = []
CSV.foreach('sales.csv', headers:true) do |row|
  if !product_contents.include?(row['customer_and_account_no'])
    db_connection {|conn| conn.exec_params("INSERT INTO customer_acct_num (name_number) VALUES ($1)", [row['customer_and_account_no']] )}
  end
  result = db_connection {|conn| conn.exec("SELECT name_number FROM customer_acct_num;")}
  result.each do |content|
    product_contents << content['name_number']
  end
end

product_contents = []
CSV.foreach('sales.csv', headers:true) do |row|
  if !product_contents.include?(row['employee'])
    db_connection {|conn| conn.exec_params("INSERT INTO employee (name_email) VALUES ($1)", [row['employee']] )}
  end
  result = db_connection {|conn| conn.exec("SELECT name_email FROM employee;")}
  result.each do |content|
    product_contents << content['name_email']
  end
end

product_contents = []
CSV.foreach('sales.csv', headers:true) do |row|
  if !product_contents.include?(row['invoice_frequency'])
    db_connection {|conn| conn.exec_params("INSERT INTO frequency (invoice_frequency) VALUES ($1)", [row['invoice_frequency']] )}
  end
  result = db_connection {|conn| conn.exec("SELECT invoice_frequency FROM frequency;")}
  result.each do |content|
    product_contents << content['invoice_frequency']
  end
end


CSV.foreach('sales.csv', headers:true) do |row|
  db_connection {|conn| conn.exec_params("INSERT INTO sales (sale_date, sale_amount, units_sold, invoice_no) VALUES ($1, $2, $3, $4, #{id_finder[row["employee"], 'employee', 'name_email']}, #{id_finder[row["customer_and_account_no"], 'customer_acct_num', 'name_number']}, #{id_finder[row["product_name"], 'product', 'product_name']}, #{id_finder[row["invoice_frequency"], 'frequency', 'invoice_frequency']})", [row['sale_date'], row['sale_amount'], row['units_sold'], row['invoice_no']] )}
end
