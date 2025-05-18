module ApplicationHelper
  # 幸福度に応じた色を返す
  def happiness_color(score)
    return "secondary" unless score
    
    case score
    when 0..3
      "danger"
    when 4..6
      "warning"
    when 7..8
      "info"
    when 9..10
      "success"
    else
      "secondary"
    end
  end
  
  # 幸福度に応じたドットの色を返す
  def happiness_dot_color(score)
    return "#6c757d" unless score
    
    case score
    when 0..3
      "#dc3545" # 赤
    when 4..6
      "#ffc107" # 黄色
    when 7..8
      "#17a2b8" # 水色
    when 9..10
      "#28a745" # 緑
    else
      "#6c757d" # グレー
    end
  end
end
