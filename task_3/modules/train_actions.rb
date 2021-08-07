# frozen_string_literal: true

require_relative 'menu'

# rubocop:disable Metrics/ModuleLength
module TrainActions
  include Menu

  def create_train_action
    trains << create_train
    puts ">>> #{ADDED_TO_LIST % 'Поезд'}"
  rescue RuntimeError => e
    puts ">>> #{e.message}"
    puts '>>> Поезд НЕ создан! Попробуйте еще раз, но учтите сообщение выше.'
    retry
  end

  def show_trains_action
    trains.any? ? show_all_items_from_list(trains) : puts(EMPTY_LIST % 'поездов')
  end

  def choose_train_from_list
    puts 'Выберите поезд из списка:'
    @current_train = list_choice_processing(list: trains)
  end

  def add_wagon_to_train_action
    return create_train_after_empty_check if trains.empty?

    choose_train_from_list
    add_next_menu(adding_menu('вагон', 'wagon'))
  end

  def add_wagon_from_list
    return create_and_add_wagon if wagons.empty?

    wagon = list_choice_processing(list: wagons)
    @current_train.add_wagon(wagons.delete(wagon)) # add to train and remove from wagons list
    successful_msg = "Вагон (#{wagon}) добавлен к поезду (#{@current_train})"
    @current_train.wagons.include?(wagon) ? puts(successful_msg) : wagons << wagon
  end

  def create_and_add_wagon
    wagon = create_wagon
    @current_train.add_wagon(wagon) # just add, wagon has not been added to wagons list before
    successful_msg = "Вагон (#{wagon}) добавлен к поезду (#{@current_train})"
    @current_train.wagons.include?(wagon) ? puts(successful_msg) : wagons << wagon
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
      @current_train.each_wagon do |wagon|
        puts "#{wagon.object_id}, #{wagon.type}, " \
             "#{wagon.free_place}, #{wagon.taken_place}"
      end
    else
      puts "У поезда (#{@current_train}) нет вагонов."
    end
  end

  def show_current_train_station_action
    return create_train_after_empty_check if trains.empty?

    choose_train_from_list
    current_station_msg = "Текущая станция: #{@current_train.current_station}"
    @current_train.route ? puts(current_station_msg) : puts(NOT_FOUND_ROUTE)
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
    @current_train.route ? @current_train.send(move_method) : puts(NOT_FOUND_ROUTE)
  end

  def add_route_to_train_action
    return create_train_after_empty_check if trains.empty?

    choose_train_from_list
    add_next_menu(adding_menu('маршрут', 'route'))
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
    puts NOT_FOUND_MSG % 'поездов'
    create_train_action
  end

  # create new entity

  def create_train_instance(number, type)
    case type
    when :passenger then PassengerTrain.new(number, type)
    when :cargo then CargoTrain.new(number, type)
    else puts 'Поезд не создан, указан несуществующий тип!'
    end
  end

  def create_train_dialog
    print 'Введите номер поезда: '
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
end
# rubocop:enable Metrics/ModuleLength
