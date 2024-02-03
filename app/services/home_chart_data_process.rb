class HomeChartDataProcess
  include BaseService

  def call(invesments:)
    context.data = {
      column_chart: column_chart_data(invesments),
      pie_chart: pie_chart_data(invesments)
    }
  end

  private

  def init_chart_data
    [
      {
        name: 'Capital',
        data: [],
      },
      {
        name: 'Value',
        data: [],
      }
    ]
  end

  def column_chart_data(invesments)
    result = init_chart_data

    (1..6).to_a.reverse.each do |i|
      time = i.months.ago.end_of_month

      # insert capital data
      result[0][:data] << [time.strftime('%m/%Y'), invesments.sum { |invesment| invesment.capital_at(time).amount }]

      # insert values data
      result[1][:data] << [time.strftime('%m/%Y'), invesments.sum { |invesment| invesment.value_at(time).amount }]
    end

    result
  end

  def pie_chart_data(invesments)
    invesments.map do |invesment|
      [invesment.name, invesment.current_value.amount]
    end
  end
end