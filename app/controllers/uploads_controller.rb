class UploadsController < ApplicationController
  before_filter :login_required unless AppConfig.authentication_method == 'noauth'

  # FIXME: Pass sessions through to allow cross-site forgery protection
  protect_from_forgery :except => [:create]

  def index
    @uploads = Upload.paginate(:all, :page => params[:page], :order => "created_at DESC")
    respond_to do |format|
      format.html
      format.xml  { render :xml => @clients.to_xml(:dasherize => false) }
    end
  end

  def show
    @upload = Upload.find(params[:id])
  end

  def new
    @upload = Upload.new
  end

  def create
    # Standard, one-at-a-time, upload action
    @upload = Upload.new(upload_params)
    @upload.uploader = session[:username]
    pkgfile = @upload.save!

    # Create entry in the package table
    metadata = Tpkg::metadata_from_package(pkgfile)
    package = PkgUtils::metadata_to_db_package(metadata.to_hash)
    Package.find_or_create(package)

    #redirect_to uploads_url
    render :text => "Success"
  end

  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy
    redirect_to uploads_url
  end

  private

  def upload_params
    params.require(:upload).permit(:upload)
  end
end

