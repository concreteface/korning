require 'pg'
require 'csv'
require 'pry'

class Idempotentiator
  attr_reader :dbcolumn, :included, :table, :contents

  def initialize(dbcolumn, table)
    @dbcolumn = dbcolumn
    @table = table
    @included = false
    @contents = []
  end

  def db_connection
    begin
      connection = PG.connect(dbname: "korning")
      yield(connection)
      ensure
      connection.close
    end
  end

  def dbsearch
    result = db_connection {|conn| conn.exec("SELECT #{dbcolumn} FROM #{table}")}
    result.each do |res|
      @contents << res["#{dbcolumn}"]
    end
  end

  def find_term
    dbsearch
    require 'pry'
    CSV.read('sales.csv').each do |array|
      array.each do |data|
        # binding.pry
        if data.include?("#{@contents[0]}") && @contents[0] != nil
          @included = true
          break
        end
      end
    end
    @included
  end
end

# puts Idempotentiator.new('product_name', 'product').find_term
