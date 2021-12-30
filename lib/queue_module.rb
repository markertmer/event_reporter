require './lib/find_class'
require 'csv'
require 'pry'

module QueueOps
  def headers(file)
    header_row = CSV.open(file){ |csv| csv.readline.join(",") }
    #headers = CSV.open(file){ |csv| csv.join(",") }
    File.write('queue.csv', "#{header_row}\n")
  end

  def subtract(attr, *criteria)
    ########################################
    queue = CSV.read 'queue.csv', headers: true, header_converters: :symbol
    clear
    criteria = criteria.each { |crit| crit.downcase }
    queue.each do |row|
      unless criteria.include?(row[attr.downcase.to_sym].downcase)# == crit.downcase
        File.write('queue.csv', row, mode: "a")
      end
    end
  end

  def add(attr, *criteria)
    ########################################
    find(attr, true, criteria)
  end

  def queue_find(attr, *criteria)
    queue = CSV.read 'queue.csv', headers: true, header_converters: :symbol
    clear
    criteria = criteria.each { |crit| crit.downcase }
    queue.each do |row|
      if criteria.include?(row[attr.downcase.to_sym].downcase)# == crit.downcase
        File.write('queue.csv', row, mode: "a")
      end
    end
  end

  def clear
    headers('queue.csv')
  end

  def print(sort_by = nil)#RENAME print!
    records = CSV.read './queue.csv', headers: true, header_converters: :symbol

    if sort_by != nil
      records = records.sort_by do |row|
        row[sort_by.to_sym]
      end
    end
#CSV.open(filename, "wb") do |csv|
#csv << ['LAST NAME'...]
#queue.each do |row|
#csv << row.valuses_at(...)
#end
#end
    rows = records.map do |row|
      row[:last_name] + "\t" +#row.value_at(3, 2, 4, 9, 7, 8, 6, 5)
      row[:first_name] + "\t" +
      row[:email_address] + "\t" +
      clean_zipcode(row[:zipcode]) + "\t" +
      row[:city] + "\t" +
      row[:state] + "\t" +
      row[:street] + "\t" +
      row[:homephone]
    end

    table =
    "LAST NAME" + "\t" +
    "FIRST NAME" + "\t" +
    "EMAIL" + "\t" +
    "ZIPCODE" + "\t" +
    "CITY" + "\t" +
    "STATE" + "\t" +
    "ADDRESS" + "\t" +
    "PHONE" + "\n" +
    rows.join("\n")
    return table
  end

  def clean_zipcode(zip)
    zip.to_s.rjust(5,"0")[0..4]
  end

  def queue_count
    queue = CSV.open './queue.csv', headers: true, header_converters: :symbol
    queue.count
  end

  def save_to(filepath, sort_by = nil)
    table = print(sort_by)
    File.write(filepath, table, mode: "w+")
  end
end
