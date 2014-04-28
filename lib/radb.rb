require "radb/version"
require "thor"
require "ADB"

module Radb

    class Application < Thor
        include Thor::Actions
        include ADB
        class_option :verbose, :type => :boolean

        #
        desc 'pull <package_name>', 'Pull database and images from android device'
        long_desc <<-LONGDESC
        `pull <package name>` will pull database and images from android device to your computer.

        Example:
        \x5> $ radb pull com.cloudjay.com -db cjay.db -i CJay
        \x5>
        LONGDESC
        option :database, :type => :string, :desc => 'Database filename', :required => true, :aliases => "-db"
        option :image_dir, :type => :string, :desc => 'Images directory', :required => true, :aliases => "-i"
        def pull(package)
            say "Pulling from " + package
        end

        #
        desc 'push <package_name>', 'Push database and images to android device'
        long_desc <<-LONGDESC
        `push <package name>` will push database and images from your computer to android device.

        Example:
        \x5> $ radb push com.cloudjay.com -db cjay.db -i CJay/
        \x5>
        LONGDESC
        option :database, :type => :string, :desc => 'Database filepath', :required => true, :aliases => "-db"
        option :image_dir, :type => :string, :desc => 'Images directory', :required => true, :aliases => "-i"
        def push(package)
            say "Pushing to " + package
        end

        #
        desc 'debug <ip>', 'Debug android device over the air'
        def debug(ip)
            # 1. Connect Android to Computer
            # run('adb wait-for-device')
            say "Ip: " + ip

        end

        #
        desc 'logcat', 'Run logcat-color for specific device'
        def logcat
        end
    end
end
