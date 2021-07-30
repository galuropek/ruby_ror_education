require_relative 'entities/route'
require_relative 'entities/train'
require_relative 'menu'
require_relative 'entities/station'
require_relative 'entities/cargo_train'
require_relative 'entities/passenger_train'
require_relative 'entities/cargo_wagon'
require_relative 'entities/passenger_wagon'

class RailRoad
  attr_reader :trains, :routes, :stations, :wagons

  TRAIN_TYPES = [:passenger, :cargo]
  NOT_FOUND_MSG = "Не найдено %s в общем списке. Нужно создать нов(ый/ую):"

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
  end

  def run
    loop do
      Menu.show_main_menu
      case gets.chomp.to_i
      when 1; start_actions_with_trains
      when 2; start_actions_with_wagons
      when 3; start_actions_with_stantions
      when 4; start_actions_with_routes
      when 0; break
      else Menu.incorrect_input_number
      end
    end
  end

  private

  # train actions

  def start_actions_with_trains
    Menu.show_train_menu
    case gets.chomp.to_i
    when 1; create_train_action
    when 2; show_trains_action
    when 3; add_wagon_to_train_action
    when 4; remove_wagon_from_train_action
    when 5; show_current_train_station_action
    when 6; move_train_to_next_station_action
    when 7; move_train_to_prev_station_action
    when 8; add_route_to_train_action
    when 9; show_route_of_train_action
    when 10; show_wagons_of_train_action
    when 0; return
    else Menu.incorrect_input_number
    end
  end

  def create_train_action
    print "Введите номер поезда: "
    train_number = gets.chomp
    train_type = choose_item_from_the_list(TRAIN_TYPES, "тип поезда")
    train = create_train(train_number, train_type)
    return unless train

    trains << train
    puts "#{train.to_s} создан и добавлен в общий список."
    start_actions_with_trains
  end

  def show_trains_action
    show_all_items_from_list(trains)
    start_actions_with_trains
  end

  def add_wagon_to_train_action
    return create_train_after_empty_check if trains.empty?

    train = choose_item_from_the_list(trains, "поезд")
    return add_wagon_to_train_action unless train

    Menu.add_wagon_to_train_menu
    case gets.chomp.to_i
    when 1; add_wagon_from_list(train)
    when 2; create_and_add_wagon_to_train(train)
    when 0; return
    else Menu.incorrect_input_number
    end
  end

  def add_wagon_from_list(train)
    return create_and_add_wagon_to_train(train) if wagons.empty?

    wagon = choose_item_from_the_list(wagons, "вагон")
    train.add_wagon(wagons.delete(wagon)) # add to train and remove from wagons list
    train.wagons.include?(wagon) ? puts("#{wagon.to_s} добавлен к #{train.to_s}") : wagons << wagon
    start_actions_with_trains
  end

  def create_and_add_wagon_to_train(train)
    puts NOT_FOUND_MSG % "вагонов"
    wagon = create_wagon_dialog
    train.add_wagon(wagon) # just add, wagon has not been added to wagons list before
    train.wagons.include?(wagon) ? puts("#{wagon.to_s} добавлен к #{train.to_s}") : wagons << wagon
    start_actions_with_trains
  end

  def remove_wagon_from_train_action
    return create_train_after_empty_check if trains.empty?

    train = choose_item_from_the_list(trains, "поезд")
    return remove_wagon_from_train_action unless train

    if train.wagons.any?
      wagon = choose_item_from_the_list(train.wagons, "вагон")
      train.remove_wagon(wagon)
      wagons << wagon # add free wagons to common list
      puts "#{wagon.to_s} удален из #{train.to_s}" unless train.wagons.include?(wagon)
    else
      puts "У #{train.to_s} нет вагонов."
      start_actions_with_trains
    end
  end

  def show_current_train_station_action
    return create_train_after_empty_check if trains.empty?

    train = choose_item_from_the_list(trains, "поезд")
    return show_current_train_station_action unless train

    train.route ? puts("Текущая станция: #{train.current_station}") : puts("Маршрут еще не установлен!")
    start_actions_with_trains
  end

  def move_train_to_next_station_action
    return create_train_after_empty_check if trains.empty?

    train = choose_item_from_the_list(trains, "поезд")
    return move_train_to_next_station_action unless train

    return puts "Маршрут еще не установлен!" unless train.route

    train.move_to_next_station
  end

  def move_train_to_prev_station_action
    return create_train_after_empty_check if trains.empty?

    train = choose_item_from_the_list(trains, "поезд")
    return move_train_to_next_station_action unless train

    return puts "Маршрут еще не установлен!" unless train.route

    train.move_to_prev_station
  end

  def create_train_after_empty_check
    puts NOT_FOUND_MSG % "поездов"
    create_train_action
  end

  def add_route_to_train_action
    return create_train_after_empty_check if trains.empty?

    train = choose_item_from_the_list(trains, "поезд")
    return add_route_to_train_action unless train

    Menu.add_route_to_train_menu
    case gets.chomp.to_i
    when 1; add_route_from_list(train)
    when 2; create_and_add_route_to_train(train)
    when 0; return
    else Menu.incorrect_input_number
    end
  end

  def add_route_from_list(train)
    return create_and_add_route_to_train(train) if routes.empty?

    route = choose_item_from_the_list(routes, "маршрут")
    train.add_route(route)
    puts "Маршрут #{route.to_s} добавлен к #{train.to_s}"
  end

  def create_and_add_route_to_train(train)
    puts NOT_FOUND_MSG % "маршрутов"
    route = create_route_dialog
    return create_and_add_route_to_train(train) unless route

    routes << route
    train.add_route(route)
    puts "Маршрут #{route.to_s} добавлен к #{train.to_s}"
  end

  def show_route_of_train_action
    return puts "Созданных поездов не найдено!" if trains.empty?

    train = choose_item_from_the_list(trains, "поезд")
    return show_route_of_train_action unless train

    if (route = train.route)
      puts "У #{train} следующий маршрут: #{route.to_s}"
    else
      puts "У #{train.to_s} пока еще нет маршрута."
    end
  end

  def show_wagons_of_train_action
    return puts "Созданных поездов не найдено!" if trains.empty?

    train = choose_item_from_the_list(trains, "поезд")
    return show_route_of_train_action unless train

    if train.wagons.any?
      puts "У #{train} следующий список вагонов:"
      show_all_items_from_list(train.wagons)
    else
      puts "У #{train.to_s} пока еще нет вагонов."
    end
  end

  # wagon actions

  def start_actions_with_wagons
    Menu.show_wagon_menu
    case gets.chomp.to_i
    when 1; create_wagon_action
    when 2; show_wagons_action
    when 0; return
    else Menu.incorrect_input_number
    end
  end

  def create_wagon_action
    wagon = create_wagon_dialog
    wagons << wagon
    puts "#{wagon.to_s} добавлен в общий список."
    start_actions_with_wagons
  end

  def create_wagon_dialog
    puts "Введите тип вагона:"
    type = choose_item_from_the_list(TRAIN_TYPES, "тип вагона")
    wagon = create_wagon(type)
    puts "Создан #{wagon.to_s}."
    wagon
  end

  def show_wagons_action
    show_all_items_from_list(wagons)
    start_actions_with_wagons
  end

  # stantion actions

  def start_actions_with_stantions
    Menu.show_station_menu
    case gets.chomp.to_i
    when 1; create_station_action
    when 2; show_station_action
    when 3; show_trains_of_station_action
    when 0; return
    else Menu.incorrect_input_number
    end
  end

  def create_station_action
    station = create_station_dialog
    stations << station
    puts "Станция #{station.to_s} добавлена в общий список."
  end

  def create_station_dialog
    print "Введите название сианции: "
    station = create_station(gets.chomp)
    puts "Создана станция: #{station.to_s}"
    station
  end

  def show_station_action
    show_all_items_from_list(stations)
    start_actions_with_stantions
  end

  def show_trains_of_station_action
    return puts "Нет созданных станций!" if stations.empty?

    station = choose_item_from_the_list(stations, "станцию")
    return show_trains_of_station_action unless station

    if station.trains.any?
      puts "У станции #{station.to_s} следующие поезда в списке:"
      show_all_items_from_list(station.trains)
    else
      puts "У станции #{station.to_s} нет поездов в списке."
    end
  end

  # route actions

  def start_actions_with_routes
    Menu.show_route_menu
    case gets.chomp.to_i
    when 1; create_route_action
    when 2; show_routes_action
    when 3; add_station_to_route_action
    when 4; remove_station_from_route_action
    when 0; return
    else Menu.incorrect_input_number
    end
  end

  def create_route_action
    route = create_route_dialog
    return start_actions_with_routes unless route

    routes << route
    puts "Маршрут #{route.to_s} добавлен в общий список."
  end

  def create_route_dialog
    return create_station_after_empty_check if stations.count < 2

    start_station = choose_item_from_the_list(stations, "начальную станцию")
    end_station = choose_item_from_the_list(stations, "конечную станцию")
    route = create_route(start_station, end_station)
    puts "Создан маршрут #{route.to_s}."
    route
  end

  def create_station_after_empty_check
    puts "Чтобы создать маршрут, нужно чтобы в списке станций количество станций было не менее двух!"
    create_station_action
  end

  def show_routes_action
    show_all_items_from_list(routes)
    start_actions_with_routes
  end

  def add_station_to_route_action
    return create_route_after_empty_check if routes.empty?

    route = choose_item_from_the_list(routes, "маршрут")
    return add_station_to_route_action unless route

    Menu.add_station_to_route_menu
    case gets.chomp.to_i
    when 1; add_station_from_list(route)
    when 2; create_and_add_station_to_route(route)
    when 0; return
    else Menu.incorrect_input_number
    end
  end

  def create_route_after_empty_check
    puts NOT_FOUND_MSG % "маршрутов"
    create_route_action
  end

  def add_station_from_list(route)
    return create_and_add_station_to_route(route) if stations.empty?

    station = choose_item_from_the_list(stations, "станцию")
    route.add_station(station)
    puts "Станция #{station.to_s} добавлена в маршрут #{route.to_s}"
  end

  def create_and_add_station_to_route(route)
    station = create_station_dialog
    stations << station
    route.add_station(station)
    puts "Станция #{station.to_s} добавлена в маршрут #{route.to_s}"
  end

  def remove_station_from_route_action
    return puts "Нет созданных маршрутов!" if routes.empty?

    route = choose_item_from_the_list(routes, "маршрут")
    return remove_station_from_route_action unless route

    if route.stations.count > 2
      puts "Можно удалить только промежуточные станции!"
      station = choose_item_from_the_list(route.intermediate_stations, "станцию")
      route.remove_station(station)
      puts "Станция #{station.to_s} удалена из маршрута #{route.to_s}."
    else
      puts "Нельзя удалить станцию если у маршурта есть только начальная и конечная."
      start_actions_with_routes
    end
  end

  # create new entity

  def create_train(number, type)
    case type
    when :passenger; PassengerTrain.new(number, type)
    when :cargo; CargoTrain.new(number, type)
    else return puts "Поезд не создан, указан несуществующий тип!"
    end
  end

  def create_wagon(type)
    case type
    when :passenger; PassengerWagon.new(type)
    when :cargo; CargoWagon.new(type)
    else return puts "Вагон не создан, указан несуществующий тип!"
    end
  end

  def create_route(first_station, last_station)
    Route.new(first_station, last_station)
  end

  def create_station(name)
    Station.new(name)
  end

  # choose item from the list

  def choose_item_from_the_list(list, item_name)
    puts "Выберите #{item_name} из списка:"
    show_all_items_from_list(list)
    list[gets.chomp.to_i.pred] || Menu.incorrect_input_number
  end

  # show all items from the list

  def show_all_items_from_list(list)
    list.each_with_index { |item, index| puts "\t#{index.next}. #{item.to_s}" }
  end
end
