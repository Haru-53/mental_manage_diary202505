class DiaryEntriesController < ApplicationController
  before_action :authenticate_user!, except: [:trial]
  before_action :set_diary_entry, only: [:show, :edit, :update, :destroy]

  # トップページ（最新10件）
  def index
    @today = Date.today
    @diary_entries = current_user.diary_entries.order(date: :desc).limit(10)
  end

  # 詳細表示
  def show; end

  # 新規作成フォーム
  def new
    @diary_entry = DiaryEntry.new(date: params[:date] || Date.today)
  end

  # 編集フォーム
  def edit; end

  # 新規作成処理
  def create
    @diary_entry = DiaryEntry.new(diary_entry_params)

    if @diary_entry.save
      flash[:notice] = "日記を保存しました！"
      redirect_to new_diary_entry_path
    else
      flash.now[:alert] = "保存に失敗しました。内容を確認してください。"
      render :new
    end
  end

  # 更新処理
def update
  if @diary_entry.update(diary_entry_params)
    flash[:notice] = '日記が更新されました。'

    # カレンダー画面にリダイレクト。更新された日記の月と年を使う
    redirect_to calendar_diary_entries_path(
      year: @diary_entry.date.year,
      month: @diary_entry.date.month
    )
  else
    flash.now[:alert] = "更新に失敗しました。"
    render :edit, status: :unprocessable_entity
  end
end

  # 削除処理
  def destroy
    @diary_entry.destroy
    flash[:notice] = '日記が削除されました。'
    redirect_to diary_entries_path
  end

  # カレンダー表示
  def calendar
    @month = params[:month].to_i
    @year = params[:year].to_i
    @month = Date.today.month if @month <= 0
    @year = Date.today.year if @year <= 0

    @date = Date.new(@year, @month, 1)
    @entries = current_user.diary_entries.where(date: @date.beginning_of_month..@date.end_of_month)
                                         .pluck(:date).map(&:day)

    @streak = calculate_streak(current_user.diary_entries)
  end

  # 検索
  def search
    @keyword = params[:keyword]
    @diary_entries = if @keyword.present?
                       current_user.diary_entries.search(@keyword).order(date: :desc)
                     else
                       DiaryEntry.none
                     end
  end

  # 月次サマリー
  def summary
    @year = params[:year].to_i
    @month = params[:month].to_i
    @year = Date.today.year if @year <= 0
    @month = Date.today.month if @month <= 0

    @summary = current_user.diary_entries.monthly_summary(@year, @month)
  end

  # グラフ表示
  def graph
    @period = params[:period] || 'month'
    @start_date = case @period
                  when 'week' then 1.week.ago.to_date
                  when 'year' then 1.year.ago.to_date
                  else 1.month.ago.to_date
                  end

    @chart_data = current_user.diary_entries.happiness_chart_data(@start_date, Date.today)
  end

  # 幸福度定義（幸福度記録ページにリダイレクト）
  def happiness_definition
    redirect_to happiness_items_path
  end

  # お試し機能（非ログインユーザー用）
  def trial
    @diary_entry = DiaryEntry.new(date: Date.today)
    render :new
  end

  private

  def set_diary_entry
    @diary_entry = current_user.diary_entries.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to diary_entries_path, alert: '指定された日記は存在しないか、アクセス権限がありません。'
  end

  def diary_entry_params
    params.require(:diary_entry).permit(
      :date,
      :reflection,
      :notes,
      :happiness_level
    ).merge(
      good_things_array: [
        params[:diary_entry]["good_things_array[0]"],
        params[:diary_entry]["good_things_array[1]"],
        params[:diary_entry]["good_things_array[2]"]
      ]
    )
  end

  def calculate_streak(diary_entries)
    dates = diary_entries.order(date: :desc).pluck(:date)
    streak = 0
    today = Date.today

    dates.each do |date|
      if date == today - streak
        streak += 1
      else
        break
      end
    end

    streak
  end
end
