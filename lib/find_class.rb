require './lib/queue_module'
require 'pry'
require 'csv'

class Find
  include QueueOps
  attr_accessor :contents

  def initialize(file)
    @contents = CSV.read file, headers: true, header_converters: :symbol
    headers(file)
  end

  def find(attr, override, *criteria)#, override = false)
    unless @contents == nil##################################
      clear if override == false
      @contents.each do |row|
        next if row[attr.downcase.to_sym] == nil
        criteria.flatten.each do |crit|  #criteria.select
          if row[attr.downcase.to_sym].downcase == crit.downcase
            File.write('queue.csv', row, mode: "a")
          end
        end
      end
      remove_duplicates #if override == true
    end
  end

  def or(query)
    clear
    commands = query.split(" or ")
    commands.each do |comm|
      args = comm.split(" ")
      attr = args[0]
      args.shift
      criteria = args.map { |crit| crit.delete("( )").split(",") }
      find(attr, true, criteria)
    end
  end

  def and(query)
    clear
    search_params = {}
    commands = query.split(" and ")
    commands.each do |comm|
      args = comm.split(" ")
      attr = args[0]
      args.shift
      criteria = args.map { |crit| crit.delete("( )").split(",") }
      search_params[attr] = criteria
    end
    search_params.each do |attr, crit|  #criteria.select
      queue = CSV.read 'queue.csv', headers: true, header_converters: :symbol
      if queue.count == 0
        find(attr, true, crit)
      else
        clear
        queue.each do |row|
          next if row[attr.downcase.to_sym] == nil
          crit.each do |cri|
            if cri.join.downcase == row[attr.downcase.to_sym].downcase
              File.write('queue.csv', row, mode: "a")
            end
          end
        end
      end
    end
  end

  def remove_duplicates
    queue = CSV.read 'queue.csv', headers: true, header_converters: :symbol
    clear
    comparison = []
    queue.each do |row|
      unless comparison.include?(row)
        File.write('queue.csv', row, mode: "a")
        comparison << row
      end
    end
  end
end
