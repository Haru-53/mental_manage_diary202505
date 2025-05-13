module CalendarHelper
  def calendar(diary_dates)
    first_day = Date.today.beginning_of_month
    last_day = Date.today.end_of_month

    content_tag :table, class: "calendar" do
      (first_day..last_day).map do |day|
        content_tag :tr do
          content_tag :td, class: (diary_dates.include?(day) ? 'checked' : '') do
            link_to day.day, diary_path(date: day)
          end
        end
      end.join.html_safe
    end
  end
end
