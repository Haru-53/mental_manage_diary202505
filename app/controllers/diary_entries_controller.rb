class DiaryEntriesController < ApplicationController
  before_action :set_diary_entry, only: [:show, :edit, :update, :destroy]
  
  # トップページ（今日の日記）
  def index
    @today = Date.today
    @diary_entry = DiaryEntry.find_by(date: @today) || DiaryEntry.new(date: @today)
  end
  
  # 新規作成フォーム
  def new
    @diary_entry = DiaryEntry.new(date: params[:date] || Date.today)
  end
  
  # 詳細表示
  def show
  end
  
  # 編集フォーム
  def edit
  end
  
  # 新規作成処理
  def create
    @diary_entry = DiaryEntry.new(diary_entry_params)
    
    if @diary_entry.save
      redirect_to @diary_entry, notice: '日記が保存されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  # 更新処理
  def update
    if @diary_entry.update(diary_entry_params)
      redirect_to @diary_entry, notice: '日記が更新されました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  # 削除処理
  def destroy
    @diary_entry.destroy
    redirect_to diary_entries_path, notice: '日記が削除されました。'
  end
  
  # カレンダー表示
  def calendar
    @month = params[:month].to_i
    @year = params[:year].to_i
    
    @month = Date.today.month if @month <= 0
    @year = Date.today.year if @year <= 0
    
    @date = Date.new(@year, @month, 1)
    @entries = DiaryEntry.where(date: @date.beginning_of_month..@date.end_of_month)
                        .pluck(:date)
                        .map { |date| date.day }
  end
  
  # 検索機能
  def search
    @keyword = params[:keyword]
    @diary_entries = if @keyword.present?
                       DiaryEntry.search(@keyword).order(date: :desc)
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
    
    @summary = DiaryEntry.monthly_summary(@year, @month)
  end
  
  # グラフ表示
  def graph
    @period = params[:period] || 'month'
    
    case @period
    when 'week'
      @start_date = 1.week.ago.to_date
    when 'month'
      @start_date = 1.month.ago.to_date
    when 'year'
      @start_date = 1.year.ago.to_date
    else
      @start_date = 1.month.ago.to_date
    end
    
    @chart_data = DiaryEntry.happiness_chart_data(@start_date, Date.today)
  end
  
  # 幸福度定義ページ
  def happiness_definition
  end
  
  private
  
  def set_diary_entry
    @diary_entry = DiaryEntry.find(params[:id])
  end

  def calendar
    diaries = current_user.diaries.where(date: Date.today.beginning_of_month..Date.today.end_of_month)
    @diary_dates = diaries.pluck(:date)

    @streak = calculate_streak(current_user.diaries)
  end

  private

  def calculate_streak(diaries)
    dates = diaries.order(date: :desc).pluck(:date)
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
  
  def diary_entry_params
    params.require(:diary_entry).permit(:date, :reflection, :notes, :happiness_level, good_things_array: [])
  end
end
