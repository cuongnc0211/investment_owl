module ApplicationHelper
  def flash_alert_class(key)
    case key
    when 'notice', 'success'
      'success'
    when 'alert', 'error'
      'danger'
    when 'warning'
      'warning'
    else
      key
    end
  end
end
