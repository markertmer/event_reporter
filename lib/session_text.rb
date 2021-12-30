class SessionText
  attr_reader :title_screen,
  :help_reminder,
  :load_reminder,
  :file_loaded,
  :find_reminder,
  :file_reminder,
  :queue_report,
  :queue_reminder,
  :no_such_file,
  :no_such_command,
  :no_file_loaded,
  :no_search_criteria

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

    @queue_report = " records found.\n"

    @queue_reminder = "
Enter 'queue print' to view, or 'queue print by <attribute>' to sort results before printing.
Enter 'queue' with 'add', 'subtract' or 'find' to refine your search with additional parameters.
Enter 'queue save to <filename>' to save the queue.
Enter 'queue clear' to begin a new search.\n"

    @bad_input = "Invalid input. Please enter a valid command.\n"

    @no_such_file = " is not a file. Make sure to include a valid filename and path.\n"

    @no_such_command = " is not a valid command. Enter 'help' to see a list of all available commands.\n"

    @no_file_loaded = "\nNo file loaded. You must load a file before running 'find' commands.\n"

    @no_search_criteria = "\nYou must include search criteria with the 'find' command. Enter 'help find' for more info.\n"

  end
end
