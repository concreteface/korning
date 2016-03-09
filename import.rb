require "pg"
require 'csv'
require_relative 'id_finder'
require_relative 'csvtodb'
require_relative 'idempotence'

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
    ensure
    connection.close
  end
end

if !Idempotentiator.new('product_name', 'product').find_term
  CsvToDb.new('product_name', 'product', 'product_name').populate
end

if !Idempotentiator.new('name_number', 'customer_acct_num').find_term
  CsvToDb.new('customer_and_account_no', 'customer_acct_num', 'name_number').populate
end

if !Idempotentiator.new('name_email', 'employee').find_term
  CsvToDb.new('employee', 'employee', 'name_email').populate
end

if !Idempotentiator.new('invoice_frequency', 'frequency').find_term
  CsvToDb.new('invoice_frequency', 'frequency', 'invoice_frequency').populate
end

if !Idempotentiator.new('invoice_no', 'sales').find_term
  CSV.foreach('sales.csv', headers:true) do |row|
    db_connection {|conn| conn.exec_params("INSERT INTO sales (sale_date, sale_amount, units_sold, invoice_no, employee_id, customer_id, product_id, frequency_id) VALUES ($1, $2, $3, $4, #{Finder.new(row["employee"], 'employee', 'name_email').find_id}, #{Finder.new(row["customer_and_account_no"], 'customer_acct_num', 'name_number').find_id}, #{Finder.new(row["product_name"], 'product', 'product_name').find_id}, #{Finder.new(row["invoice_frequency"], 'frequency', 'invoice_frequency').find_id})", [row['sale_date'], row['sale_amount'], row['units_sold'], row['invoice_no']] )}
  end
end
