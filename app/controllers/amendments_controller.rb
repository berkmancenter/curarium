class AmendmentsController < ApplicationController
  def index
    @amendments = Work.find(params[:work_id]).amendments
  end
end
