# frozen_string_literal: true

require_relative 'menu'

module RouteActions
  include Menu

  def create_route_action
    routes << create_route
    puts ">>> #{ADDED_TO_LIST % 'Маршрут'}"
  rescue RuntimeError => e
    puts ">>> #{e.message}"
    puts '>>> Маршрут НЕ создан! Попробуйте еще раз, но учтите сообщение выше.'
    retry
  end

  def show_routes_action
    routes.any? ? show_all_items_from_list(routes) : puts(EMPTY_LIST % 'маршрутов')
  end

  def add_station_to_route_action
    return create_route_after_empty_check if routes.empty?

    choose_route_from_list
    add_next_menu(adding_menu('станцию', 'station'))
  end

  def choose_route_from_list
    puts 'Выберите маршрут из списка:'
    @current_route = list_choice_processing(list: routes)
  end

  def add_station_from_list
    return create_and_add_station if stations.empty?

    not_added_stations = stations - @current_route.stations
    return puts 'Все созданные станции уже присутсвуют в маршруте!' if not_added_stations.empty?

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
    return puts 'Нет созданных маршрутов!' if routes.empty?

    choose_route_from_list
    if @current_route.intermediate_stations.any?
      puts 'Можно удалить только промежуточные станции!'
      station = list_choice_processing(list: @current_route.intermediate_stations)
      @current_route.remove_station(station)
      puts "Станция (#{station}) удалена из маршрута (#{@current_route})."
    else
      puts 'Нельзя удалить станцию если у маршурта есть только начальная и конечная!'
    end
  end

  def create_route_after_empty_check
    puts NOT_FOUND_MSG % 'маршрутов'
    create_route_action
  end

  # create new entity

  def create_route_instance(first_station, last_station)
    Route.new(first_station, last_station)
  end

  def create_route_dialog
    check_empty_stations_for_route
    puts 'Выберите начальную станцию:'
    start_station = list_choice_processing(list: stations)
    puts 'Выберите конечную станцию:'
    end_station = list_choice_processing(list: stations)
    [start_station, end_station]
  end

  def check_empty_stations_for_route
    while stations.count < 2
      puts NOT_FOUND_STATIONS % stations.count
      create_station_action
    end
  end

  def create_route
    start_station, end_station = create_route_dialog
    route = create_route_instance(start_station, end_station)
    puts ">>> Создан маршрут (#{route})!"
    route
  end
end
