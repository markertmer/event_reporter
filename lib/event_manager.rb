require "csv"
puts "EventManager Initialized!"

#puts File.exist? "event_attendees.csv"

# contents = File.read "event_attendees.csv"
# puts contents

def clean_zipcode(zip)
  zip.to_s.rjust(5,"0")[0..4]
end

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
contents.each do |row|
  name = row[:first_name]
  zipcode = row[:zipcode]
  #require 'pry'; binding.pry
  puts "#{name} #{clean_zipcode(zipcode)}"
end

# lines = File.readlines "event_attendees.csv"
# lines.each_with_index do |line, index|
#   next if index == 0
#   columns = line.split(",")
#   name = columns[2]
#   puts name
# end

# row_index = -1
# lines.each do |line|
#   row_index += 1
#   next if row_index == 0
#   # next if line == " ,RegDate,first_Name,last_Name,Email_Address,HomePhone,Street,City,State,Zipcode\n"
#   columns = line.split(",")
#   name = columns[2]
#   puts name
# end
# p lines
