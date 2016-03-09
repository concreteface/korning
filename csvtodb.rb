require "pg"
require 'csv'
require 'pry'

class CsvToDb
  attr_reader :csvrow, :table, :dbcolumn

  def initialize(csvrow, table, dbcolumn)
    @csvrow = csvrow
    @table = table
    @dbcolumn = dbcolumn
    @product_contents = []
  end

  def db_connection
    begin
      connection = PG.connect(dbname: "korning")
      yield(connection)
      ensure
      connection.close
    end
  end

  def add_to_contents
    result = db_connection {|conn| conn.exec("SELECT #{dbcolumn} FROM #{table};")}
    result.each do |content|
      @product_contents << content["#{dbcolumn}"]
    end
  end

  def populate
    @product_contents = []
    CSV.foreach('sales.csv', headers:true) do |row|
      if !@product_contents.include?(row["#{csvrow}"])
        db_connection {|conn| conn.exec_params("INSERT INTO #{table} (#{dbcolumn}) VALUES ($1)", [row["#{csvrow}"]] )}
      end
      add_to_contents
    end
  end
end
