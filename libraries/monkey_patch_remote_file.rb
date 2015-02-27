require 'json'
require 'open-uri'

class Chef
  class Provider
    class RemoteFile
      class HTTP
        alias old_fetch fetch

        def fetch
          # check whether we have peach, check '/etc/peach/conf.json', if not existing, then revert to original fetch
          puts "In peach monkey patched remote_file #{uri} #{uri.class}"

          begin
            puts "Try to load from /etc/peach/conf.json"
            file = ::File.read('/etc/peach/conf.json')

            puts "Parse json"
            peach_conf = JSON.parse(file)

            puts "parsed #{peach_conf}"
            peach_server = peach_conf['server']
            puts "Got peach server #{peach_server}"

            qs = 'file_url=' +  URI::encode(uri.to_s)
            uri = 'http://' + peach_server + '?' + qs

            http = Chef::HTTP::Simple.new(uri, http_client_opts)
            tempfile = http.streaming_request(uri, headers)
            if tempfile
              update_cache_control_data(tempfile, http.last_response)
              tempfile.close
            end
            tempfile

          rescue => error
            puts "Not able to find peach conf or there is an error while loading it #{error}"
            return old_fetch
          end
        end
      end
    end
  end
end
