class ClientsController < ApplicationController
  before_filter :login_required unless AppConfig.authentication_method == 'noauth'

  # list out the clients
  def index
    @mainmodel = Client

    sort = case params[:sort]
           when 'name'              then 'name'
           when 'name_reverse'      then 'name DESC'
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

    @clients = @mainmodel.
      # noop if query is nil
      where(conditions_query, *conditions_values).
      order(sort).
      page(params[:page]).
      to_a # kind of weird

    respond_to do |format|
      format.html
      format.xml  { render :xml => @clients.to_xml(:dasherize => false) }
    end
  end

  def show
    sort =  params[:sort]
    # If a sort was not defined we'll make one default
    if sort.nil?
      sort = 'name'
    end
    sort_by = sort.split("_")[0]
    sort_direction = sort.split("_")[1]

    # Get list of packages that are installed on this client
    @client = Client.find(params[:id])

    # BEGIN NEW CODE
    @installed_packages = {}
    @client.client_packages.each do |client_package|
      client_package.tpkg_home = "unknown" if client_package.tpkg_home.nil? or client_package.tpkg_home.empty?
      @installed_packages[client_package.tpkg_home] ||= []
      @installed_packages[client_package.tpkg_home] << client_package.package
    end

    # sort the result
    @installed_packages.each do |tpkg_home, packages|
      packages.sort! do  |a,b|
        a.send(sort_by) != nil ? akey = a.send(sort_by) : akey = ""
        b.send(sort_by) != nil ? bkey = b.send(sort_by) : bkey = ""
        if sort_direction == "reverse"
          bkey <=> akey
        else
          akey <=> bkey
        end
      end
    end
    # END NEW CODE
   
#    @installed_packages = @client.client_packages.collect{ |cp| cp.package}.flatten
#
#    # sort the result
#    @installed_packages.sort! do  |a,b|
#      a.send(sort_by) != nil ? akey = a.send(sort_by) : akey = ""
#      b.send(sort_by) != nil ? bkey = b.send(sort_by) : bkey = ""
#      if sort_direction == "reverse"
#        bkey <=> akey
#      else
#        akey <=> bkey
#      end
#    end

    # get list of installation history for this client
    @installation_history = ClientPackageHistory.where(client_id: params[:id]).order("created_at")

    respond_to do |format|
      format.html
      format.xml  { render :xml => @client.to_xml(:include => :client_packages, :dasherize => false) }
    end
  end
end
