class HomeChartDataProcess
  include BaseService

  def call(invesments:)
    context.data = {
      column_chart: column_chart_data(invesments),
      pie_chart: pie_chart_data(invesments)
    }
  end

  private

  def column_chart_data(invesments)
    {}
  end

  def pie_chart_data(invesments)
    {}
  end
end