require 'paperclip'

# Allow ".tpkg" as an extension for files with the MIME type "application/octet-stream".
mime = MIME::Types["application/octet-stream"].first
mime.add_extensions "tpkg"

# https://github.com/mime-types/ruby-mime-types/issues/84
silence_warnings do
  MIME::Types.index_extensions mime
end
