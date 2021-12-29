class Session
  attr_reader :contents

  def initialize
    # @contents = CSV.read 'full_event_attendees.csv', headers: true, header_converters: :symbol
    # headers('full_event_attendees.csv')
  end

  def load(file = 'full_event_attendees.csv')
    @contents = CSV.read file, headers: true, header_converters: :symbol
    headers(file)
  end

  def headers(file)
    headers = CSV.open(file){ |csv| csv.readline.join(",") }
    #headers = CSV.open(file){ |csv| csv.join(",") }
    File.write('queue.csv', "#{headers}\n")
  end

  def find(attr, override, *criteria)#, override = false)
    unless @contents == nil##################################
      clear if override == false
      @contents.each do |row|
        next if row[attr.downcase.to_sym] == nil
        criteria.each do |crit|
          if row[attr.downcase.to_sym].downcase == crit.downcase
            File.write('queue.csv', row, mode: "a")
          end
        end
      end
    end
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

  def add(attr, crit)
    find(attr, true, crit)
  end

  def clear
    headers('queue.csv')
  end

  def help(command = nil)
    help_text = CSV.read './lib/help.csv', headers: true, header_converters: :symbol

    if command == nil
      help_commands = []
      help_text.each do |row|
        help_commands << row[:command]
      end
      return help_commands
    else
      match = help_text.find do |row|
        row[:command] == command.downcase
      end
      if match[:parameters] == nil
        return match[:command] + " - " + match[:description]
      else
        return match[:command] + " " + match[:parameters] + " - " + match[:description]
      end
    end
  end

  def print(sort_by = nil)
    records = CSV.read './queue.csv', headers: true, header_converters: :symbol

    if sort_by != nil
      records = records.sort_by do |row|
        row[sort_by.to_sym]
      end
    end

    rows = records.map do |row|
      row[:last_name] + "\t" +
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

  def save_to(filepath, sort_by = nil)
    table = print(sort_by)
    File.write(filepath, table, mode: "w+")
  end
end
