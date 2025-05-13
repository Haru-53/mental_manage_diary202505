class HappinessItemsController < ApplicationController
  def index
    @happiness_items = HappinessItem.all
    @calculated_score = HappinessItem.weighted_score
    @happiness_score = HappinessScore.first_or_initialize
  end

  def update_all
    params[:items].each do |id, item_params|
      item = HappinessItem.find(id)
      item.update(item_params.permit(:name, :description, :weight, :satisfied))
    end
    redirect_to happiness_items_path
  end

  def update_score
    score = HappinessScore.first_or_initialize
    score.update(value: params[:happiness_score][:value])
    redirect_to happiness_items_path
  end
end
