class AmendmentsController < ApplicationController
  def index
    @amendments = Record.find(params[:work_id]).amendments
  end
end
