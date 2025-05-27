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
    if params[:id]
      @diary_entry = DiaryEntry.find(params[:id])
    else
      @diary_entry = DiaryEntry.new(date: params[:date])
    end
    # Twitter共有用のテキストを定義
    @twitter_share_text = "3good things メンタル管理日記を書きました"
  end

  # 編集フォーム（new.html.erbを再利用）
  def edit
    @diary_entry = DiaryEntry.find(params[:id])
    # Twitter共有用のテキストを定義（editでも使う場合）
    @twitter_share_text = "3good things メンタル管理日記を書きました"
    render :new
  end

  # 新規作成処理
  def create
    # 既に同じ日付のエントリーがあるか確認
    existing_entry = DiaryEntry.find_by(date: diary_entry_params[:date], user_id: current_user.id)

    if existing_entry
      # すでにある場合は更新（例：good_things_arrayなども対応するなら更新処理を追加）
      flash[:alert] = "この日の日記はすでに存在します。編集してください。"
      redirect_to edit_diary_entry_path(existing_entry)
    else
      @diary_entry = current_user.diary_entries.new(diary_entry_params)
      if @diary_entry.save
        flash[:notice] = "日記を保存しました"
        redirect_to calendar_diary_entries_path
      else
        # エラー時も共有テキストを設定
        @twitter_share_text = "3good things メンタル管理日記を書きました"
        render :new
      end
    end
  end

  # 更新処理
  def update
    @diary_entry = current_user.diary_entries.find(params[:id])

    if @diary_entry.update(diary_entry_params)
      flash[:notice] = "日記を保存しました！"
      redirect_to calendar_diary_entries_path
    else
      flash.now[:alert] = "更新に失敗しました。"
      # エラー時も共有テキストを設定
      @twitter_share_text = "3good things メンタル管理日記を書きました"
      render :edit
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

    @diary_entries = current_user.diary_entries.where(date: @date.beginning_of_month..@date.end_of_month)
    @entries = @diary_entries.pluck(:date).map(&:day)
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

  # 幸福度定義ページへリダイレクト
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
      :date, :reflection, :notes, :happiness_level,
      good_things_array: []  # 配列として許可
    )
  end

  def calculate_streak(diary_entries)
    dates = diary_entries.order(date: :desc).pluck(:date)
    streak = 0
    today = Date.today

    dates.each do |date|
      break if date != today - streak
      streak += 1
    end

    streak
  end
end
