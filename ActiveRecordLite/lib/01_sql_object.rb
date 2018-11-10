require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    @sym ||= DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        "#{self.table_name}"
    SQL

    @sym.first.map {|e| e.to_sym}
  end

  def self.finalize!
    meths = self.columns
    meths.each do |meth|
      define_method(meth) do
        self
        attributes[meth]
      end

      define_method("#{meth}=") do |value|
        attributes[meth] = value
      end
    end

  end

  def self.table_name=(table_name)

  end

  def self.table_name
    @lower = eval("self").to_s.downcase
    "#{@lower}s"
  end

  def self.all
    DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        "#{self.table_name}"
    SQL

  end

  def self.parse_all(results)
    array = []
    results.each do |obj|
      array << self.new(obj)
    end

    array
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      unless self.class.columns.include?(attr_name.to_sym)
        # convert attr_name to symbol & see if it is a column. if # NOTE: raise below error
        raise "unknown attribute '#{attr_name}'"
      end
      self.send("#{attr_name}=", value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
