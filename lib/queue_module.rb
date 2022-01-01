require './lib/find_class'
require 'csv'
require 'pry'

module QueueOps
  def headers(file)
    header_row = CSV.open(file){ |csv| csv.readline.join(",") }
    File.write('queue.csv', "#{header_row}\n")
  end

  def queue_subtract(attr, *criteria)
    queue = CSV.read 'queue.csv', headers: true, header_converters: :symbol
    clear
    criteria = criteria.flatten.each { |crit| crit.downcase }
    queue.each do |row|
      unless criteria.include?(row[attr.downcase.to_sym].to_s.downcase)# == crit.downcase
        File.write('queue.csv', row, mode: "a")
      end
    end
  end

  def queue_add(attr, find_class, *criteria)
    find_class.find(attr, true, criteria)
  end

  def queue_find(attr, *criteria)
    queue = CSV.read 'queue.csv', headers: true, header_converters: :symbol
    clear
    criteria = criteria.flatten.each { |crit| crit.downcase }
    queue.each do |row|
      if criteria.include?(row[attr.downcase.to_sym].to_s.downcase)
        File.write('queue.csv', row, mode: "a")
      end
    end
  end

  def clear
    headers('queue.csv')
  end

  def queue_print(sort_by = nil)
    records = CSV.read './queue.csv', headers: true, header_converters: :symbol

    if sort_by != nil
      records = records.sort_by do |row|
        row[sort_by.to_sym].to_s.downcase
      end
    end

    rows = records.map do |row|
      row[:last_name].to_s + "\t" +
      row[:first_name].to_s + "\t" +
      row[:email_address].to_s + "\t" +
      clean_zipcode(row[:zipcode]).to_s + "\t" +
      row[:city].to_s + "\t" +
      row[:state].to_s + "\t" +
      row[:street].to_s + "\t" +
      row[:homephone].to_s
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

  def queue_save_to(filepath, sort_by = nil)
    table = queue_print(sort_by)
    File.write(filepath, table, mode: "w+")
  end
end
