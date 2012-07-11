# Copyright (c) 2012 Arxopia LLC.
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the Arxopia LLC nor the names of its contributors
#     	may be used to endorse or promote products derived from this software
#     	without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL ARXOPIA LLC BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
#OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
#OF THE POSSIBILITY OF SUCH DAMAGE.

module Keigan
	module Cli

		# Application class for Keigan
		#
		class Application
			attr_accessor :database

			# Initializes a CLI Application
			#
			def initialize
				@options = {}
				@database = {}

				@options[:debug] = false
			end

			# Loads the configuration file
			#
			# @param file Path to configuration file
			# @param in_memory_config [Boolean] If the configuration is in memory
			#
			def load_config(file=CONFIG_FILE, in_memory_config=false)
				if File.exists?(file) == true or in_memory_config == true
					begin
						if in_memory_config
							yaml = YAML::load(file)
						else
							yaml = YAML::load(File.open(file))
						end

						@database = yaml["database"]
						@report = yaml["report"]

						puts @database.inspect if @options[:debug]

						#If no values were entered put a default value in
						@report.each do |k, v|
							if v == nil
								@report[k] = "No #{k}"
							end
						end
					rescue => e
						puts "[!] Error loading configuration! - #{e.message}"
						exit
					end
				else
					puts "[!] Configuration file does not exist!"
					exit
				end
			end

			# Establishes an [ActiveRecord::Base] database connection
			#
			def db_connect
				begin
					if @database["adapter"] == nil
						puts "[!] #{@database['adapter']}" if @options[:debug]

						return false, "[!] Invalid database adapter, please check your configuration file"
					end

					ActiveRecord::Base.establish_connection(@database)
					ActiveRecord::Base.connection

				rescue ActiveRecord::AdapterNotSpecified => ans
					puts "[!] Database adapter not found, please check your configuration file"
					puts "#{ans.message}\n #{ans.backtrace}" if @options[:debug]

					exit
				rescue ActiveRecord::AdapterNotFound => anf
					puts "[!] Database adapter not found, please check your configuration file"
					puts "#{anf.message}\n #{anf.backtrace}" if @options[:debug]

					exit
				rescue => e
					puts "[!] Exception! #{e.message}\n #{e.backtrace}"
				end
			end

			# Tests the database connection
			#
			# @return [Boolean] True on successful, False on failure
			def test_connection?
				begin

					db_connect

					if ActiveRecord::Base.connected? == true
						return true, "[*] Connection Test Successful"
					else
						return false, "[!] Connection Test Failed"
					end
				rescue => e
					puts "[!] Exception! #{e.message}\n #{e.backtrace}"
				end
			end

			# Parses all the command line
			#
			def parse_options
				begin
					opts = OptionParser.new do |opt|
						opt.banner =	"#{APP_NAME} v#{VERSION}\n#{AUTHOR}\n#{SITE}\n\n"
						opt.banner << "Usage: #{APP_NAME} [options]"
						opt.separator('')
						opt.separator('Configuration Options')

						opt.on('--config-file FILE', "Loads configuration settings for the specified file. By default #{APP_NAME} loads #{CONFIG_FILE}") do |option|
							if File.exists?(option) == true
								@options[:config_file] = option
							else
								puts "[!] Specified configuration file does not exist. Please specify a file that exists."
								exit
							end
						end

						opt.separator('')
						opt.separator('Database Options')

						opt.on('--test-connection','Tests the database connection settings') do |option|
							@options[:test_connection] = option
						end

						opt.separator ''
						opt.separator 'Other Options'

						opt.on_tail('-v', '--version', "Shows application version information") do
							puts "#{APP_NAME}: #{VERSION}\nRuby Version: #{RUBY_VERSION}\nRubygems Version: #{Gem::VERSION}"
							exit
						end

						opt.on('-d','--debug','Enable Debug Mode (More verbose output)') do |option|
							@options[:debug] = true
						end

						opt.on_tail("-?", "--help", "Show this message") do
							puts opt.to_s + "\n"
							exit
						end
					end

					if ARGV.length != 0
						opts.parse!
					else
					#	puts opts.to_s + "\n"
					#	exit
					end
				rescue OptionParser::MissingArgument => m
					puts opts.to_s + "\n"
					exit
				rescue OptionParser::InvalidOption => i
					puts opts.to_s + "\n"
					exit
				end
			end

			# Main Application loop, handles all of the command line arguments and
			#parsing of files on the command line
			#
			def run
				parse_options

				if @options[:debug] == true
					puts "[*] Enabling Debug Mode"
				end

				if @options[:config_file] != nil
					load_config @options[:config_file]
				else
					load_config
				end

				if @options[:test_connection] != nil
					result = test_connection?

					puts "#{result[1]}"
					exit
				end

				db_connect

				puts "Keigan Web Interface at http://localhost:8969/"
				Keigan::Web::Application.run!

			end
		end
	end
end
