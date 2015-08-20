class CollectionFieldsController < ApplicationController
  def index
    @collection_fields = CollectionField.all
  end

  def new
    @collection_field = CollectionField.new
  end

  # POST /collection_fields
  # POST /collections/1/collection_fields
  def create
    @collection_field = CollectionField.new collection_field_params

    if @collection_field.name.nil?
      @collection_field.name = @collection_field.display_name.gsub( / /, '' ).underscore
    end

    if @collection_field.save
      redirect_to collection_fields_path
    end
  end
  
  private

  def collection_field_params
    params.require(:collection_field).permit(:name, :display_name)
  end
end

