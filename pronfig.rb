#!/usr/bin/ruby
require 'yaml'


pronfig_path = ENV['PRONFIG_PATH']
aliases_path = pronfig_path + "/tmp/pronfig_aliases"
config_path = pronfig_path + "/config/config.yml"

date_config = File.mtime(config_path)
date_aliases = File.exist?(aliases_path) && File.mtime(aliases_path)

exit 1 if date_aliases && (date_config < date_aliases)

projects = YAML.load(File.read("#{pronfig_path}/config/config.yml"))
aliases = "#!/bin/bash\n"
servers =  "ss() {\n"
servers << "  case `basename $PWD` in\n"

projects.each do |p|
  aliases << "alias #{p["name"]}-folder=\"cd #{p["path"]}\"\n"

  puts File.basename(p["path"])

  servers << "  \"#{File.basename(p["path"])}\")                      echo_h1 \"Running #{p["name"]} port #{p["port"]}\n"
  servers << "                                                        echo_h2 \"#{p["domain"]}\n"
  servers << "                                                        echo_separator\n"
  servers << "                                                        #{p["s"]}\n"
  servers << "                                                        ;;\n"
end
  servers << "  *)                                                    echo_warning \"Not in a valid project folder.\""
  servers << "                                                        ;;"
  servers << "  esac\n"
  servers << "}"


cmds = aliases + servers

File.open( pronfig_path + "/tmp/pronfig_aliases", 'w+') {|f| f.write(cmds) }
