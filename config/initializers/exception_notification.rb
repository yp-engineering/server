require "action_mailer"
require "exception_notifier"
require "exception_notifier_helper"
require "exception_notifiable"

# Email receipients for the exception_notification plugin
ExceptionNotifier.exception_recipients = %w(webmaster)
ExceptionNotifier.sender_address = "\"TPKG Server App Error\""

