#!/usr/bin/ruby
#
#
# author: Eric Ohtake
#
# This program fetches the Java Plugin(s) 64 bits version currently installed on the system.
#
# Example of the keys name found for each Java Plugin Version:
# - Key for the version v8u65 HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Products\4EA42A62D9304AC4784BF2681408560F
# - Key for the version v8u66 HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Products\4EA42A62D9304AC4784BF2681408660F
#                                                                            32 bits 4EA42A62D9304AC4784BF2381208660F
# You may want to install other versions on a testing machine and investigate its keys.

  # This regex holds the Java version/update key string up to the where it is the same for all versions.
  regexp = '4EA42A62D9304AC4784BF268140.*'
  javaplugin64 = ' '
    if RUBY_PLATFORM.downcase.include?('mswin') or RUBY_PLATFORM.downcase.include?('mingw32')
      require 'win32/registry'

      # Counter for the iteration as the keys are found, this is increased by 1..
      # i = 0

      # Preparing the array that will hold the keys found in registry.
      versionkeys = Array.new

      # This while must be improved, since I'm iterating only 3x, and it must be until there is key match in the registry.
      #while i < 6

        # Opens the registry key, and uses the regex to match the root of the key. Then add all the matches to the array.
        # For now, the block captures 3 registry keys if exists. Looking for a better way to count until is over, instead of hard coding.
        Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\\Classes\\Installer\\Products') do | version |
          version.each_key do | key |
            if /#{regexp}/ =~ key
            versionkeys << key
              #i += 1
            end
          end
        end
      #end

      # Uses the key found above to open the values accordingly to the version.
      versionkeys.each do | versionkey |
        Win32::Registry::HKEY_LOCAL_MACHINE.open("SOFTWARE\\Classes\\Installer\\Products\\#{versionkey}") do |reg|
          reg.each do | name,type,data |
            if name.eql?('ProductName')
              javaplugin64 << data.concat('; ')
              puts javaplugin64
            end
          end
        end
      end
    end
