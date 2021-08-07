# frozen_string_literal: true

require_relative 'menu'

module WagonActions
  include Menu

  def create_wagon_action
    wagons << create_wagon
    puts ">>> #{ADDED_TO_LIST % 'Вагон'}"
  rescue RuntimeError => e
    puts ">>> #{e.message}"
    puts '>>> Вагон НЕ создан! Попробуйте еще раз, но учтите сообщение выше.'
    retry
  end

  def show_wagons_action
    wagons.any? ? show_all_items_from_list(wagons) : puts(EMPTY_LIST % 'вагонов')
  end

  def take_place_action
    return create_wagon_after_empty_check if wagons.empty?

    choose_wagon_from_list
    type = @current_wagon.type
    take_place(type) ? print_place_message(type, :taken) : print_place_message(type, :over)
  end

  def take_place(type)
    case type
    when :passenger
      @current_wagon.take_place
    when :cargo
      print 'Введите объем добавляемого груза: '
      @current_wagon.take_place(gets.chomp.to_f)
    else
      raise 'Incorrect wagon type!'
    end
  end

  def print_place_message(w_type, m_type)
    puts format(TAKE_PLACE[w_type][m_type], @current_wagon.taken_place, @current_wagon.place)
  end

  def choose_wagon_from_list
    puts 'Выберите вагон из списка:'
    @current_wagon = list_choice_processing(list: wagons)
  end

  def create_wagon_after_empty_check
    puts NOT_FOUND_MSG % 'вагонов'
    create_wagon_action
  end

  # create new entity

  def create_wagon_instance(type, extra_arg)
    case type
    when :passenger then PassengerWagon.new(type, extra_arg)
    when :cargo then CargoWagon.new(type, extra_arg)
    else puts 'Вагон не создан, указан несуществующий тип!'
    end
  end

  def create_wagon_dialog
    puts 'Введите тип вагона:'
    type = list_choice_processing(list: TRAIN_TYPES)
    print WAGON_EXTRA_ARG[type]
    extra_arg = gets.chomp.to_f
    [type, extra_arg]
  end

  def create_wagon
    type, extra_arg = create_wagon_dialog
    wagon = create_wagon_instance(type, extra_arg)
    puts ">>> Создан вагон (#{wagon})!"
    wagon
  end
end
