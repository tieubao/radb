require "radb/version"
require "radb/helper"
require "thor"
include Radb

module Radb
    class Application < Thor

        include Thor::Actions
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

        # Connect devices to PC
        # Run command:
        # `radb debug`
        # 1. Show list devices
        # 2. Choose device if there are many devices
        # 3. Get chosen ip address
        # 4. Enable ota debug
        #
        # Run command:
        # `radb debug -s <serial>`
        # 1. Get choose ip address
        # 2. Enable ota debug
        long_desc <<-LONGDESC
        `otadebug -s <serial>` will enable ota debug.

        Example:
        \x5> $ otadebug -s 81f42e1
        \x5>
        LONGDESC
        desc 'otadebug -s <serial>', 'Debug android device over the air'
        option :serial, :type => :string, :desc => 'Device serial', :required => false, :aliases => '-s'
        def otadebug

            if options[:serial]
                device = options[:serial]
            else
                device = choose_device
            end

            if device.nil?
                raise "Device not found"
            end

            target = { :serial => device }

            ip = get_ipv4(target)
            say "Target ip: " + ip
            run "adb #{which_one(target)} tcpip 5555", :verbose => false
            run "adb #{which_one(target)} connect #{ip}", :verbose => false
        end

        #
        desc 'logcat', 'Run logcat-color for specific device'
        def logcat
        end
    end
end
