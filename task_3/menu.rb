module Menu

  NOT_FOUND_MSG = "Не найдено %s в общем списке. Нужно создать новый(ую):"
  MENU_MSG_PATTERN = "Введите %s, чтобы %s."
  INCORRECT_INPUT_NUMBER_MSG = "Введен некоррекнтый номер! Нужно выбрать один из предложенных вариантов!"
  ENTER_YOUR_CHOICE = "Введите ваш выбор: "
  ADDED_TO_LIST = "%s добавлен(а) в общий список!"
  EMPTY_LIST = "Не найдено созданных %s!"

  def main_menu
    [
      { action: "завершить программу", method: :exit },
      { action: "выполнить операции с поездами", method: :start_actions_with_trains },
      { action: "выполнить операции с вагонами", method: :start_actions_with_wagons },
      { action: "выполнить операции cо станциями", method: :start_actions_with_stantions },
      { action: "выполнить операции c маршрутами", method: :start_actions_with_routes },
    ]
  end

  def train_actions_menu
    [
      { action: "создать поезд", method: :create_train_action },
      { action: "посмотреть список созданных поездов", method: :show_trains_action },
      { action: "прицепить поезду вагон", method: :add_wagon_to_train_action },
      { action: "отцепить вагон от поезда", method: :remove_wagon_from_train_action },
      { action: "посмотреть список вагонов поезда", method: :show_wagons_of_train_action },
      { action: "посмотреть текущую станцию поезда", method: :show_current_train_station_action },
      { action: "отправить поезд на следующую станцию", method: :move_train_to_next_station_action },
      { action: "отправить поезд на предыдущую станцию", method: :move_train_to_prev_station_action },
      { action: "назначить маршрут", method: :add_route_to_train_action },
      { action: "посмотреть маршрут поезда", method: :show_route_of_train_action },
    ].unshift(back_action)
  end

  def wagon_menu
    [
      { action: "создать вагон", method: :create_wagon_action },
      { action: "посмотреть список созданных вагонов", method: :show_wagons_action },
    ].unshift(back_action)
  end

  def station_menu
    [
      { action: "создать станцию", method: :create_station_action },
      { action: "посмотреть список созданных станций", method: :show_station_action },
      { action: "посмотреть список поездов на станций", method: :show_trains_of_station_action },
    ].unshift(back_action)
  end

  def route_menu
    [
      { action: "создать маршрут", method: :create_route_action },
      { action: "посмотреть список созданных маршрутов", method: :show_routes_action },
      { action: "добавить станцию в маршрут", method: :add_station_to_route_action },
      { action: "удалить станцию из маршрута", method: :remove_station_from_route_action },
    ].unshift(back_action)
  end

  def adding_menu(entity_name, entity_key)
    [
      { action: "выбрать #{entity_name} из существующих", method: "add_#{entity_key}_from_list".to_sym },
      { action: "создать новый(ую) #{entity_name}", method: "create_and_add_#{entity_key}".to_sym },
    ].unshift(back_action)
  end

  def back_action
    { action: "вернуться назад", method: :back }
  end
end
