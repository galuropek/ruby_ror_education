# frozen_string_literal: true

require_relative 'entities/route'
require_relative 'entities/train'
require_relative 'entities/station'
require_relative 'entities/cargo_train'
require_relative 'entities/passenger_train'
require_relative 'entities/cargo_wagon'
require_relative 'entities/passenger_wagon'

require_relative 'modules/menu'
require_relative 'modules/train_actions'
require_relative 'modules/wagon_actions'
require_relative 'modules/station_actions'
require_relative 'modules/route_actions'

class RailRoad
  include Menu
  include TrainActions
  include WagonActions
  include StationActions
  include RouteActions

  attr_reader :trains, :routes, :stations, :wagons

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
    @menu = main_menu
    @prev_menu = nil
    @current_train = nil
    @current_route = nil
    @current_wagon = nil
  end

  def run
    loop do
      action_choice_processing
    end
  end

  private

  # menu actions

  def action_choice_processing
    show_menu_items
    input_index = input_index_value
    send @menu[input_index][:method]
  rescue NoMethodError => e
    puts e.message
    puts INCORRECT_INPUT_NUMBER_MSG
    retry
  end

  def list_choice_processing(list:)
    show_all_items_from_list(list)
    input_index = input_index_value
    raise NoMethodError, 'Not found item by 0 number' if input_index.zero?

    list[input_index.pred]
  rescue NoMethodError => e
    puts e.message
    puts INCORRECT_INPUT_NUMBER_MSG
    retry
  end

  def input_index_value
    print ENTER_YOUR_CHOICE
    input_index = gets.chomp.strip
    raise NoMethodError, 'Empty input value' if input_index.empty?
    raise NoMethodError, 'No digits found' if input_index !~ /\d+/

    input_index[/(\d+)/, 1].to_i
  end

  def show_all_items_from_list(list)
    list.each_with_index { |item, index| puts "\t#{index.next}. #{item}" }
  end

  def show_menu_items
    @menu.each_with_index { |item, index| puts format(MENU_MSG_PATTERN, index, item[:action]) }
  end

  def add_next_menu(next_menu)
    @prev_menu = @menu
    @menu = next_menu
  end

  def back
    @menu = @prev_menu
    @prev_menu = main_menu
  end

  # actions

  def start_actions_with_trains
    add_next_menu(train_actions_menu)
  end

  def start_actions_with_wagons
    add_next_menu(wagon_menu)
  end

  def start_actions_with_stantions
    add_next_menu(station_menu)
  end

  def start_actions_with_routes
    add_next_menu(route_menu)
  end
end
