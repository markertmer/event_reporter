require 'csv'
require './lib/session_class'
require './lib/find_class'
require './lib/queue_class'
require './help_class'
require 'pry'

RSpec.describe "Session" do
  it "exists" do
    session = Session.new
  end

  it "loads a file" do
    session = Session.new
    session.load('event_attendees.csv')
    expect(session.contents.count).to be 19
  end

  it "has a default file loaded" do
    session = Session.new
    expect(session.contents.count).to be 5175
    session.load('event_attendees.csv')
    expect(session.contents.count).to be 19
  end

  it "starts with an empty queue" do
    session = Session.new
    queue = CSV.read 'queue.csv', headers: true, header_converters: :symbol
    expect(queue.count).to be 0
  end

  it "finds records that match criteria" do
    session = Session.new
    session.find("first_name", "John")
    queue = CSV.read 'queue.csv', headers: true, header_converters: :symbol
    expect(queue.count).to be 63
  end

  it "clears the queue" do
    session = Session.new
    session.find("first_name", "John")
    queue = CSV.read 'queue.csv', headers: true, header_converters: :symbol
    expect(queue.count).to be 63
    session.clear
    queue = CSV.read 'queue.csv', headers: true, header_converters: :symbol
    expect(queue.count).to be 0
  end

  it "lists all available commands" do
    session = Session.new
    expect(session.help).to eq(["find","help","load","queue count","queue clear","queue export html","queue print","queue print by","queue save to","quit"])
  end

  it "gives a description for each command" do
    session = Session.new
    expect(session.help("load")).to eq("load <filename> - Loads the specified file for search operations.")
    expect(session.help("queue clear")).to eq("queue clear - Empties the queue for the next search.")
  end

  it "prints the queue in a table" do
    session = Session.new
    session.load('event_attendees.csv')
    session.find("first_name", "shannon")
    queue = CSV.read 'queue.csv', headers: true, header_converters: :symbol
    expect(session.print).to eq("LAST NAME\tFIRST NAME\tEMAIL\tZIPCODE\tCITY\tSTATE\tADDRESS\tPHONE\nWarner\tShannon\tgkjordandc@jumpstartlab.com\t03082\tLyndeborough\tNH\t186 Crooked S Road\t(603) 305-3000\nDavis\tShannon\tltb3@jumpstartlab.com\t98122\tSeattle\tWA\tCampion 1108 914 E. Jefferson\t530-355-7000")
  end

  it "prints the queue sorted by the chosen attribute" do
    session = Session.new
    session.load('event_attendees.csv')
    session.find("first_name", "shannon")
    queue = CSV.read 'queue.csv', headers: true, header_converters: :symbol
    expect(session.print("last_name")).to eq("LAST NAME\tFIRST NAME\tEMAIL\tZIPCODE\tCITY\tSTATE\tADDRESS\tPHONE\nDavis\tShannon\tltb3@jumpstartlab.com\t98122\tSeattle\tWA\tCampion 1108 914 E. Jefferson\t530-355-7000\nWarner\tShannon\tgkjordandc@jumpstartlab.com\t03082\tLyndeborough\tNH\t186 Crooked S Road\t(603) 305-3000")
  end

  it "saves the queue to a file" do
    session = Session.new
    session.find("City", "Salt Lake City")
    session.save_to('./lib/city_sample.csv')
    file = File.read('./lib/city_sample.csv')
    expect(file).to eq(session.print)
  end

  it "sorts & saves the queue" do
    session = Session.new
    session.find("state", "DC")
    session.save_to('./lib/state_sample.csv', "last_name")
    file = File.read('./lib/state_sample.csv')
    expect(file).to eq(session.print("last_name"))
    session.clear
  end
end
