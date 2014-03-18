class AmendmentsController < ApplicationController
  def index
    @amendments = Record.find(params[:record_id]).amendments
  end
end
