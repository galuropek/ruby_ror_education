# frozen_string_literal: true

require_relative 'menu'

module StationActions
  include Menu

  def create_station_action
    stations << create_station
    puts ">>> #{ADDED_TO_LIST % 'Станция'}"
  rescue RuntimeError => e
    puts ">>> #{e.message}"
    puts '>>> Станция НЕ создана! Попробуйте еще раз, но учтите сообщение выше.'
    retry
  end

  def show_station_action
    stations.any? ? show_all_items_from_list(stations) : puts(EMPTY_LIST % 'станций')
  end

  def show_trains_of_station_action
    return puts 'Нет созданных станций!' if stations.empty?

    station = list_choice_processing(list: stations)
    if station.trains.any?
      station.each_train { |train| puts "#{train.number}, #{train.type}, #{train.wagons.count}" }
    else
      puts "У станции (#{station}) нет поездов в списке."
    end
  end

  # create new entity

  def create_station_instance(name)
    Station.new(name)
  end

  def create_station_dialog
    print 'Введите название станции: '
    gets.chomp.strip
  end

  def create_station
    name = create_station_dialog
    station = create_station_instance(name)
    puts ">>> Создана станция (#{station})!"
    station
  end
end
