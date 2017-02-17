class Admin::DocumentsController < ApplicationController
  before_action -> { require_access_level :admin }

  def new
    @doc = Docs::Document.new
  end

  def create
    @doc = Docs::Document.new

    if @doc.save_doc doc_params
      flash[:success] = 'document saved'
      OMNILOGGER.admin ltag("CREATE document: #{doc_params[:name]}")
      redirect_to admin_dashboard_index_path
    else
      flash[:error] = 'document was unable to be saved'
      render 'new'
    end
  end

  def edit
    @doc = Docs::Document.find params[:id]
  end

  def update
    @doc = Docs::Document.find params[:id]

    if @doc.save_doc doc_params
      flash[:success] = 'document updated'
      OMNILOGGER.admin ltag("UPDATE document: #{doc_params[:name]}")
      redirect_to admin_dashboard_index_path
    else
      flash[:error] = 'document was unable to be updated'
      render 'edit'
    end
  end

  private

  def doc_params
    params.require(:docs_document).permit(:name, :title, :body)
  end
end
