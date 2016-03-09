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
    CSV.read('sales.csv').each do |array|
      array.each do |data|
        if data.include?("#{@contents[0]}")
          included = true
        end
      end
    end
    included
  end
end
