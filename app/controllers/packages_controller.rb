require 'rexml/document'

class PackagesController < ApplicationController
  before_filter :login_required unless AppConfig.authentication_method == 'noauth'
#  skip_before_filter :verify_authenticity_token

  def index
    # TODO name should really be Package.default_search_attribute
    @search_str = params[:name]
    sort = case params[:sort]
           when 'count'              then 'count'
           when 'count_reverse'      then 'count DESC'
           when 'name'              then 'name'
           when 'name_reverse'      then 'name DESC'
           else
              # If a sort was not defined we'll make one default
              params[:sort] = 'name'
           end

    conditions_values = []
    if exact_match
      conditions_query = "name = ?"
      conditions_values << @search_str
    else
      conditions_query = "name LIKE ?"
      conditions_values << '%' + @search_str + '%'
    end if @search_str

    @packages = Package.counts.
      # noop if query is nil
      where(conditions_query, *conditions_values).
      order(sort).
      page(params[:page]).
      to_a # kind of weird

    respond_to do |format|
      format.html
      format.xml  { render :xml => @packages.to_xml(:dasherize => false) }
    end
  end

  # lists out all packages
  def detail_index
    # whether we want to show all packages or only packages
    # that are currently installed
    show_all = true
    @mainmodel = Package
    @search_str = params[:name]
    sort = case params[:sort]
           when 'name'               then 'name'
           when 'name_reverse'       then 'name DESC'
           when 'filename'           then 'filename'
           when 'filename_reverse'   then 'filename DESC'
           when 'maintainer'         then 'maintainer'
           when 'maintainer_reverse' then 'maintainer DESC'
           when 'os'                 then 'os'
           when 'os_reverse'         then 'os DESC'
           when 'arch'               then 'arch'
           when 'arch_reverse'       then 'arch DESC'
           else
             params[:sort] = 'name'
           end


    conditions_values = []
    if exact_match
      conditions_query = "name = ?"
      conditions_values << @search_str
    else
      conditions_query = "name LIKE ?"
      conditions_values << '%' + @search_str + '%'
    end if @search_str

    if show_all
      join = nil
    else
      join = "inner join client_packages as cp on packages.id = cp.package_id"
    end

    @packages = Package.
      group(:id).
      # noop if query is nil
      where(conditions_query, *conditions_values).
      order(sort).
      joins(join).
      page(params[:page]).
      to_a

    respond_to do |format|
      format.html
      format.xml  { render :xml => @packages.to_xml(:dasherize => false) }
    end
  end

  def show
    @package = Package.find(params[:id])
    @installed_on = @package.client_packages.collect{ |cp| cp.client}.flatten
    @installed_on.sort!{ |a,b| a.name <=> b.name}

    # Get additional info regarding the package file
    @uploads = []
    if @package.filename
      @uploads = @package.uploads
    end

    respond_to do |format|
      format.html
      format.xml  { render :xml => @package.to_xml(:include => :client_packages, :dasherize => false) }
    end

  end

  def download
    filename = params[:filename]
    if File.exists?(File.join(AppConfig.upload_path, filename))
      redirect_to :controller => :tpkg, :action => filename
    else
      render :text => "File #{filename} doesn't exist on repo."
    end
  end

  def query_files_listing
    filename = params[:filename]
    if filename && File.exists?(File.join(AppConfig.upload_path, filename))
      fip = Tpkg::files_in_package(File.join(AppConfig.upload_path, filename))
      files = (fip[:root] | fip [:reloc]).join("<br/>")
    else
      files = "File #{filename} doesn't exist on repo."
    end
    render :text => files
  end

  protected
  def add
    name = params[:id]
    package = Package.new
    package.name = name
    package.save
  end

  def delete_all
    Package.delete_all
  end

  # assuming that the packages list is sent from POST param with the following
  # format
  # {p1[name]=>"package name", p1[version]=>"1.2", p2[name]=>"package name", p2[version]="3.1.3"}
  #
  def get_packages_info(params)
    packages = Hash.new
    params.each do | key, value |
      packages.merge!({key=> value}) if (key != "action" && key != "controller")
    end
    return packages
  end

  def exact_match
    params[:exact] && params[:exact] == '1' || false
  end
end
