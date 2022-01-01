class SessionText
  attr_reader :title_screen,
  :help_reminder,
  :load_reminder,
  :file_loaded,
  :find_reminder,
  :file_reminder,
  :search_report,
  :queue_reminder,
  :no_such_file,
  :no_such_command,
  :no_file_loaded,
  :no_file_for_attributes,
  :no_search_criteria,
  :no_spaces,
  :and_or_or_not_and_and_or,
  :queue_cleared,
  :queue_empty,
  :save_complete,
  :no_such_directory,
  :only_add_or_subtract,
  :queue_report,
  :quit_message,
  :invalid_input,
  :help_hint

  def initialize
    @title_screen = "
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-------------------------------- EVENT REPORTER --------------------------------
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n\n"

    @help_reminder = "
Enter 'help' at any time to see a list of available functions.\n"

    @load_reminder = "
Enter the command 'load <filename>' to load your file.\nUsing the 'load' command without a filename will load the default file.\n"

    @file_loaded = " loaded. Records are now ready for searching.\n"

    @find_reminder = "
Enter 'help find' for info on how to use the 'find' command.\n"

    @search_report = " records found.\n"

    @queue_reminder = "
Enter 'queue print' to view, or 'queue print by <attribute>' to sort results before printing.
Enter 'queue' followed by 'add', 'subtract' or 'find' with <attribute> <criteria> to refine your search.
Enter 'queue save to <filename>' to save the queue.
Enter 'queue clear' to begin a new search.
Enter 'queue find <attribute> <criteria>' to further narrow your search.\n" 

    @bad_input = "Invalid input. Please enter a valid command.\n"

    @no_such_file = " is not a file. Make sure to include a valid filename and path.\n"

    @no_such_command = " is not a valid command. Enter 'help' to see a list of all available commands.\n"

    @no_file_loaded = "\nNo file loaded. You must load a file before running 'find' commands.\n"

    @no_file_for_attributes = "\nNo file loaded. You must load a file before you can view a list of attributes.\n"

    @no_search_criteria = "\nYou must include search criteria with the 'find' command. Enter 'help find' for more info.\n"

    @no_spaces = "\nMake sure to include spaces between each word of your input!\n"

    @and_or_or_not_and_and_or = "\nThe 'and' and 'or' operators cannot be used in the same 'find' command.\n"

    @queue_cleared = "\nThe queue has been cleared.\n"

    @queue_empty = "\nThe queue is empty. You must use 'find' to populate the queue before additional 'queue' commands can be carried out."

    @save_complete = "\nFile successfully saved to "

    @no_such_directory = "\nPlease save your file to an existing directory.\n"

    @only_add_or_subtract = "\n'add' and 'subtract' functions must be used in separate commands.\n"

    @queue_report = " records are now in the queue.\n"

    @quit_message = "\nGoodbye!\n"

    @invalid_input = "\nInvalid input. Please check your syntax and try again.\n"

    @help_hint = "\nEnter 'help <command>' for more info on how to use any of the available commands.\n"

  end
end
