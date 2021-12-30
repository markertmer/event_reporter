require './lib/session_text.rb'
require './lib/find_class.rb'
require 'pry'
require 'csv'

module Session

  def start
    @text = SessionText.new

    @help_text = CSV.read './lib/help.csv', headers: true, header_converters: :symbol
    @help_commands = @help_text.map { |row| row[:command] }

    puts @text.title_screen
    #sleep 2
    puts @text.help_reminder
    #sleep 2
    puts @text.load_reminder
    command_router
  end

  def command_router
    puts "\n> "
    input = gets.chomp.downcase
    if input.start_with?("load")
      load_filter(input)
    elsif input.start_with?("help")
      help_filter(input)
    elsif input.start_with?("find")
      find_filter(input)
    end
  end

  def load_filter(input)
    if input != "load"
      file = input.split(" ")[1]
      if File.file?(file)
        load file
      else
        puts "\n" + "'#{file}'" + @text.no_such_file
        command_router
      end
    elsif input == "load"
      load
    end
  end

  def load(file = 'full_event_attendees.csv')
    @find = Find.new(file)
    puts "\n" + "'#{file}'" + @text.file_loaded
    #sleep 2
    puts @text.find_reminder
    command_router
  end

  def help_filter(input)
    if input == "help"
      help
      command_router
    elsif input != "help"
      command = input.split(" ").slice(1..-1).join(" ")
      if @help_commands.include? command
        help(command)
        command_router
      else
        puts "\n" + "'#{command}'" + @text.no_such_command
        command_router
      end
    end
  end

  def help(command = nil)
    #help_text = CSV.read './lib/help.csv', headers: true, header_converters: :symbol

    if command == nil
      puts @help_commands
    else
      match = @help_text.find do |row|
        row[:command] == command
      end
      if match[:parameters] == nil
        puts "\n" + match[:command] + " - " + match[:description]
      else
        puts "\n" + match[:command] + " " + match[:parameters] + " - " + match[:description]
      end
    end
  end

  def find_filter(input)
    
end
