require 'active_record_extensions'
require 'configuration_manager_hash'
require 'configuration_manager'

AppConfig = ConfigurationManager.new_manager
if AppConfig.authentication_method == "restful-authentication"
  include AuthenticatedSystem
elsif AppConfig.authentication_method == "sso"
  include YPCAuthenticatedSystem
end
