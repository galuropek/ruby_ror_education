require_relative 'entities/route'
require_relative 'entities/train'
require_relative 'menu'
require_relative 'entities/station'
require_relative 'entities/cargo_train'
require_relative 'entities/passenger_train'
require_relative 'entities/cargo_wagon'
require_relative 'entities/passenger_wagon'

class RailRoad
  include Menu

  attr_reader :trains, :routes, :stations, :wagons

  TRAIN_TYPES = [:passenger, :cargo]

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
    @menu = main_menu
    @prev_menu = nil
    @current_train = nil
    @current_route = nil
  end

  def run
    loop do
      action_choice_processing
    end
  end

  private

  # menu actions

  def action_choice_processing(menu: @menu)
    show_menu_items(menu: @menu)
    input_index = input_index_value
    send menu[input_index][:method]
  rescue NoMethodError => e
    puts e.message
    puts INCORRECT_INPUT_NUMBER_MSG
    retry
  end

  def list_choice_processing(list:)
    show_all_items_from_list(list)
    input_index = input_index_value
    # в списке на экране юзера значения начинаются с 1,
    # ожидаются только положительные числа в input, т.к. дальше идет метод pred для индексов в массиве
    raise NoMethodError, "Not found item by 0 number" if input_index.zero?
    list[input_index.pred]
  rescue NoMethodError => e
    puts e.message
    puts INCORRECT_INPUT_NUMBER_MSG
    retry
  end

  def input_index_value
    print ENTER_YOUR_CHOICE
    input_index = gets.chomp.strip
    raise NoMethodError, "Empty input value" if input_index.empty? # защита от пустого ввода
    raise NoMethodError, "No digits found" if input_index !~ /\d+/ # проверка на наличие цифр
    input_index[/(\d+)/, 1].to_i
  end

  def show_all_items_from_list(list)
    list.each_with_index { |item, index| puts "\t#{index.next}. #{item.to_s}" }
  end

  def show_menu_items(menu: @menu)
    menu.each_with_index { |item, index| puts MENU_MSG_PATTERN % [index, item[:action]] }
  end

  def set_next_menu(next_menu)
    @prev_menu = @menu
    @menu = next_menu
  end

  def back
    @menu = @prev_menu
    @prev_menu = main_menu
  end

  # train actions

  def start_actions_with_trains
    set_next_menu(train_actions_menu)
  end

  def create_train_action
    trains << create_train
    puts ">>> " + ADDED_TO_LIST % "Поезд"
  rescue RuntimeError => e
    puts ">>> #{e.message}"
    puts ">>> Поезд НЕ создан! Попробуйте еще раз, но учтите сообщение выше."
    retry
  end

  def show_trains_action
    trains.any? ? show_all_items_from_list(trains) : puts(EMPTY_LIST % "поездов")
  end

  def choose_train_from_list
    puts "Выберите поезд из списка:"
    @current_train = list_choice_processing(list: trains)
  end

  def add_wagon_to_train_action
    return create_train_after_empty_check if trains.empty?

    choose_train_from_list
    set_next_menu(adding_menu("вагон", "wagon"))
  end

  def add_wagon_from_list
    return create_and_add_wagon if wagons.empty?

    wagon = list_choice_processing(list: wagons)
    @current_train.add_wagon(wagons.delete(wagon)) # add to train and remove from wagons list
    @current_train.wagons.include?(wagon) ? puts("Вагон (#{wagon}) добавлен к поезду (#{@current_train})") : wagons << wagon
  end

  def create_and_add_wagon
    wagon = create_wagon
    @current_train.add_wagon(wagon) # just add, wagon has not been added to wagons list before
    @current_train.wagons.include?(wagon) ? puts("Вагон (#{wagon}) добавлен к поезду (#{@current_train})") : wagons << wagon
  end

  def remove_wagon_from_train_action
    return create_train_after_empty_check if trains.empty?

    choose_train_from_list
    if @current_train.wagons.any?
      wagon = list_choice_processing(list: @current_train.wagons)
      @current_train.remove_wagon(wagon)
      puts "Вагон (#{wagon}) удален из поезда (#{@current_train})"
      wagons << wagon # add free wagons to common list
    else
      puts "У поезда (#{@current_train}) нет вагонов."
    end
  end

  def show_wagons_of_train_action
    return create_train_after_empty_check if trains.empty?

    choose_train_from_list
    if @current_train.wagons.any?
      puts "У поезда (#{@current_train}) следующий список вагонов:"
      show_all_items_from_list(@current_train.wagons)
    else
      puts "У поезда (#{@current_train}) нет вагонов."
    end
  end

  def show_current_train_station_action
    return create_train_after_empty_check if trains.empty?

    choose_train_from_list
    @current_train.route ? puts("Текущая станция: #{@current_train.current_station}") : puts("Маршрут еще не установлен!")
  end

  def move_train_to_next_station_action
    move_train_to_station(:move_to_next_station)
  end

  def move_train_to_prev_station_action
    move_train_to_station(:move_to_prev_station)
  end

  def move_train_to_station(move_method)
    return create_train_after_empty_check if trains.empty?

    choose_train_from_list
    @current_train.route ? @current_train.send(move_method) : puts("Маршрут еще не установлен!")
  end

  def add_route_to_train_action
    return create_train_after_empty_check if trains.empty?

    choose_train_from_list
    set_next_menu(adding_menu("маршрут", "route"))
  end

  def add_route_from_list
    return create_and_add_route if routes.empty?

    route = list_choice_processing(list: routes)
    @current_train.add_route(route)
    puts "Маршрут (#{route}) добавлен к (#{@current_train})"
  end

  def create_and_add_route
    route = create_route
    routes << route
    @current_train.add_route(route)
    puts "Маршрут (#{route}) добавлен к (#{@current_train})"
  end

  def show_route_of_train_action
    return create_train_after_empty_check if trains.empty?

    choose_train_from_list
    if (route = @current_train.route)
      puts "У поезда (#{@current_train}) следующий маршрут: #{route}"
    else
      puts "У #{@current_train} пока еще нет маршрута."
    end
  end

  def create_train_after_empty_check
    puts NOT_FOUND_MSG % "поездов"
    create_train_action
  end

  # wagon actions

  def start_actions_with_wagons
    set_next_menu(wagon_menu)
  end

  def create_wagon_action
    wagons << create_wagon
    puts ">>> " + ADDED_TO_LIST % "Вагон"
  rescue RuntimeError => e
    puts ">>> #{e.message}"
    puts ">>> Вагон НЕ создан! Попробуйте еще раз, но учтите сообщение выше."
    retry
  end

  def show_wagons_action
    wagons.any? ? show_all_items_from_list(wagons) : puts(EMPTY_LIST % "вагонов")
  end

  # stantion actions

  def start_actions_with_stantions
    set_next_menu(station_menu)
  end

  def create_station_action
    stations << create_station
    puts ">>> " + ADDED_TO_LIST % "Станция"
  rescue RuntimeError => e
    puts ">>> #{e.message}"
    puts ">>> Станция НЕ создана! Попробуйте еще раз, но учтите сообщение выше."
    retry
  end

  def show_station_action
    stations.any? ? show_all_items_from_list(stations) : puts(EMPTY_LIST % "станций")
  end

  def show_trains_of_station_action
    return puts "Нет созданных станций!" if stations.empty?

    station = list_choice_processing(list: stations)
    if station.trains.any?
      puts "У станции (#{station}) следующие поезда в списке:"
      show_all_items_from_list(station.trains)
    else
      puts "У станции (#{station}) нет поездов в списке."
    end
  end

  # route actions

  def start_actions_with_routes
    set_next_menu(route_menu)
  end

  def create_route_action
    routes << create_route
    puts ">>> " + ADDED_TO_LIST % "Маршрут"
  rescue RuntimeError => e
    puts ">>> #{e.message}"
    puts ">>> Маршрут НЕ создан! Попробуйте еще раз, но учтите сообщение выше."
    retry
  end

  def show_routes_action
    routes.any? ? show_all_items_from_list(routes) : puts(EMPTY_LIST % "маршрутов")
  end

  def add_station_to_route_action
    return create_route_after_empty_check if routes.empty?

    choose_route_from_list
    set_next_menu(adding_menu("станцию", "station"))
  end

  def choose_route_from_list
    puts "Выберите маршрут из списка:"
    @current_route = list_choice_processing(list: routes)
  end

  def add_station_from_list
    return create_and_add_station if stations.empty?

    not_added_stations = stations - @current_route.stations
    return puts "Все созданные станции уже присутсвуют в маршруте!" if not_added_stations.empty?

    station = list_choice_processing(list: not_added_stations)
    @current_route.add_station(station)
    puts "Станция (#{station}) добавлена в маршрут (#{@current_route})"
  end

  def create_and_add_station
    station = create_station
    stations << station
    @current_route.add_station(station)
    puts "Станция (#{station}) добавлена в маршрут (#{@current_route})"
  end

  def remove_station_from_route_action
    return puts "Нет созданных маршрутов!" if routes.empty?

    choose_route_from_list
    if @current_route.intermediate_stations.any?
      puts "Можно удалить только промежуточные станции!"
      station = list_choice_processing(list: @current_route.intermediate_stations)
      @current_route.remove_station(station)
      puts "Станция (#{station}) удалена из маршрута (#{@current_route})."
    else
      puts "Нельзя удалить станцию если у маршурта есть только начальная и конечная!"
    end
  end

  def create_route_after_empty_check
    puts NOT_FOUND_MSG % "маршрутов"
    create_route_action
  end

  # create new entity

  def create_train_instance(number, type)
    case type
    when :passenger; PassengerTrain.new(number, type)
    when :cargo; CargoTrain.new(number, type)
    else return puts "Поезд не создан, указан несуществующий тип!"
    end
  end

  def create_train_dialog
    print "Введите номер поезда: "
    train_number = gets.chomp
    train_type = list_choice_processing(list: TRAIN_TYPES)
    [train_number, train_type]
  end

  def create_train
    number, type = create_train_dialog
    train = create_train_instance(number, type)
    puts ">>> Создан поезд (#{train})!"
    train
  end

  def create_wagon_instance(type)
    case type
    when :passenger; PassengerWagon.new(type)
    when :cargo; CargoWagon.new(type)
    else return puts "Вагон не создан, указан несуществующий тип!"
    end
  end

  def create_wagon_dialog
    puts "Введите тип вагона:"
    list_choice_processing(list: TRAIN_TYPES)
  end

  def create_wagon
    type = create_wagon_dialog
    wagon = create_wagon_instance(type)
    puts ">>> Создан вагон (#{wagon})!"
    wagon
  end

  def create_route_instance(first_station, last_station)
    Route.new(first_station, last_station)
  end

  def create_route_dialog
    check_empty_stations_for_route
    puts "Выберите начальную станцию:"
    start_station = list_choice_processing(list: stations)
    puts "Выберите конечную станцию:"
    end_station = list_choice_processing(list: stations)
    [start_station, end_station]
  end

  def check_empty_stations_for_route
    while stations.count < 2
      puts "Для создания маршрута нужно, чтобы было создано не меннее 2 станций! На данный момент в списке #{stations.count} станций!"
      create_station_action
    end
  end

  def create_route
    start_station, end_station = create_route_dialog
    route = create_route_instance(start_station, end_station)
    puts ">>> Создан маршрут (#{route})!"
    route
  end

  def create_station_instance(name)
    Station.new(name)
  end

  def create_station_dialog
    print "Введите название станции: "
    gets.chomp.strip
  end

  def create_station
    name = create_station_dialog
    station = create_station_instance(name)
    puts ">>> Создана станция (#{station})!"
    station
  end
end
