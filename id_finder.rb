require "pg"
require 'csv'
require 'pry'

class Finder
  attr_reader :table, :column, :search_term

  def initialize(search_term, table, column)
    @table = table
    @column = column
    @search_term = search_term
  end

  def find_id
    @result = db_connection {|conn| conn.exec("SELECT * FROM #{table} WHERE #{column} = '#{search_term}'")}
      @result[0]['id']
  end
end
