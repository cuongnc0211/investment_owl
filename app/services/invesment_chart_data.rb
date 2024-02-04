class InvesmentChartData
  include BaseService

  def call(invesment:)
    context.data = process_data(invesment)
  end

  private

  def test_data
    {
      labels: ["January", "February", "March", "April", "May"],
      datasets: [
        {
          label: "Column Chart",
          data: [10, 20, 30, 40, 50],
          type: "bar", # This indicates a column chart
          backgroundColor: "rgba(75,192,192,0.5)" # Set your desired background color
        },
        {
          label: "Line Chart",
          data: [5, 15, 25, 35, 45],
          type: "line", # This indicates a line chart
          borderColor: "rgba(255,99,132,1)", # Set your desired line color
          fill: false
        }
      ]
    }
  end

  def init_value_data
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

  def init_profit_data
    [
      {
        name: 'Profit(amount)',
        data: [],
      },
      {
        name: 'Profit(percentage)',
        data: [],
      }
    ]
  end

  def process_data(invesment)
    result = {}
    result[:value_chart] = init_value_data
    result[:profit_chart] = []

    (1..6).to_a.reverse.each do |i|
      time = i.months.ago.end_of_month

      capital = invesment.capital_at(time).amount
      value = invesment.value_at(time).amount

      # insert calue chart data
      result[:value_chart][0][:data] << [time.strftime('%m/%Y'), capital]
      result[:value_chart][1][:data] << [time.strftime('%m/%Y'), value]

      # insert profit chart data
      result[:profit_chart] << [time.strftime('%m/%Y'), cal_profit_percent(capital, value)]
    end

    result
  end

  def cal_profit_percent(capital, value)
    (((value - capital) / capital) * 100.0).round(2)
  end
end