require './lib/session_text.rb'
require './lib/find_class.rb'
require './lib/queue_module.rb'
require 'pry'
require 'csv'

module Session
  include QueueOps

  def start
    @text = SessionText.new

    @help_text = CSV.read './lib/help.csv', headers: true, header_converters: :symbol
    @help_commands = @help_text.map { |row| row[:command] }

    puts @text.title_screen
    sleep 2
    puts @text.help_reminder
    sleep 2
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
    elsif input.start_with?("queue")
      queue_filter(input)
    elsif input == "attributes"
      attributes
    elsif input == "quit"
      quit
    else
      puts @text.invalid_input
      puts @text.help_reminder
      command_router
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
    sleep 2
    puts @text.find_reminder
    command_router
  end

  def help_filter(input)
    if input == "help"
      help
    elsif input != "help"
      command = input.split(" ").slice(1..-1).join(" ")
      if @help_commands.include? command
        help(command)
      else
        puts "\n" + "'#{command}'" + @text.no_such_command
      end
    end
    command_router
  end

  def help(command = nil)
    if command == nil
      puts "\n" + @help_commands.join("\t") + "\n" + @text.help_hint
    else
      match = @help_text.find do |row|
        row[:command] == command
      end
      if match[:parameters] == nil
        puts "\n" + match[:command] + "\n\n" + match[:description]
      else
        puts "\n" + match[:command] + " " + match[:parameters] + "\n\n" + match[:description] + "\n\nEXAMPLES:\n"
        puts match[:examples].split("\\n")
      end
    end
  end

  def find_filter(input)
    query = input.split(" ").slice(1..-1).join(" ")
    if input == "find"
      puts @text.no_search_criteria
    elsif !input.include?(" ")
      puts @text.no_spaces
    elsif @find == nil
      puts @text.no_file_loaded
    elsif input.include?(" or ") && input.include?(" and ")
      puts @text.and_or_or_not_and_and_or
    elsif input.include?(" or ")
      @find.or(query)
      puts "\n" + queue_count.to_s + @text.search_report
      sleep 2
      puts @text.queue_reminder
    elsif input.include?(" and ")
      @find.and(query)
      puts "\n" + queue_count.to_s + @text.search_report
      sleep 2
      puts @text.queue_reminder
    else
      criteria = query.split(" ")
      attr = criteria.shift
      @find.find(attr, false, criteria)
      puts "\n" + queue_count.to_s + @text.search_report
      sleep 2
      if queue_count != 0
        puts @text.queue_reminder
      elsif queue_count == 0
        puts @text.find_reminder
      end
    end
    command_router
  end

  def queue_filter(input)
    if input == "queue"
      puts @text.queue_reminder
    elsif input == "queue count"
      puts "\nThere are " + queue_count.to_s + " records in the queue.\n"
    elsif queue_count == 0
      puts @text.queue_empty
    elsif input == "queue clear"
      clear
      puts @text.queue_cleared
    elsif input.start_with?("queue print")
      sort_by = input.split(" by ")[1]
      puts queue_print(sort_by)
    elsif input.start_with?("queue save to ")
      filepath = input.gsub("queue save to ", "")
      path = filepath.gsub(filepath.split("/")[-1], "")
      if path != "" && !File.exist?(path)
        puts @text.no_such_directory
      else
        queue_save_to(filepath)
        puts @text.save_complete + filepath + "\n"
      end
    elsif input.start_with?("queue add") || input.start_with?("queue subtract") || input.start_with?("queue find")
      query = input.split(" ").slice(2..-1).join(" ")
      if !input.include?(" ")
        puts @text.no_spaces
      elsif input.include?("add") && input.include?("subtract")
        puts @text.only_add_or_subtract
      else
        criteria = query.split(" ")
        attr = criteria.shift
        if input.include?(" add ")
          queue_add(attr, @find, criteria)
        elsif input.include?(" subtract ")
          queue_subtract(attr, criteria)
        elsif input.include?(" find ")
          queue_find(attr, criteria)
        end
        puts "\n" + queue_count.to_s + @text.queue_report
        sleep 2
        puts @text.queue_reminder
      end
    end
    command_router
  end

  def attributes
    if @find == nil
      puts @text.no_file_for_attributes
    else
      puts "\n" + CSV.open('queue.csv') { |csv| csv.readline.join("\t").downcase } + "\n"
    end
    command_router
  end

  def quit
    puts @text.quit_message
    clear
    exit!
  end
end
