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
        option :database, :type => :string, :desc => 'Database filename', :required => true, :aliases => "-d"
        option :image_dir, :type => :string, :desc => 'Images directory', :required => true, :aliases => "-i"
        option :serial, :type => :string, :desc => 'Device serial', :required => false, :aliases => '-s'
        def pull(package)

            target = get_target(options[:serial])
            database_path = "/data/data/#{package}/databases/" + options[:database]
            images_path = "/sdcard/DCIM/" + options[:image_dir]

            say " > Pull database from " + database_path
            run "adb #{which_one(target)} shell \"run-as #{package} chmod 666 #{database_path}\"", :verbose => false
            run "adb #{which_one(target)} pull #{database_path}", :verbose => false
            run "adb #{which_one(target)} shell \"run-as #{package} chmod 600 #{database_path}\"", :verbose => false

            say " > Pull images from " + images_path
            run "adb #{which_one(target)} pull #{images_path} #{options[:image_dir]} ", :verbose => false
        end

        #
        desc 'push <package_name>', 'Push database and images to android device'
        long_desc <<-LONGDESC
        `push <package name>` will push database and images from your computer to android device.

        Example:
        \x5> $ radb push com.cloudjay.com -d cjay.db -i CJay/
        \x5>
        LONGDESC
        option :database, :type => :string, :desc => 'Database filepath', :required => true, :aliases => "-d"
        option :image_dir, :type => :string, :desc => 'Images directory', :required => true, :aliases => "-i"
        option :serial, :type => :string, :desc => 'Device serial', :required => false, :aliases => '-s'
        def push(package)

            target = get_target(options[:serial])
            database_dir = "/data/data/#{package}/databases/"
            database_path = options[:database]
            images_path = "/sdcard/DCIM/" + options[:image_dir]

            say " > Push database from " + database_path + " to " + database_dir
            run "adb #{which_one(target)} shell \"run-as #{package} chmod 666  #{database_dir}#{database_path}\"", :verbose => false
            run "adb #{which_one(target)} push '#{database_path}' '#{database_dir}' ", :verbose => false
            run "adb #{which_one(target)} shell \"run-as #{package} chmod 600  #{database_dir}#{database_path}\"", :verbose => false
            run "adb #{which_one(target)} push '#{options[:image_dir]}' '#{images_path}'", :verbose => false
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
        \x5> $ radb otadebug -s 81f42e1
        \x5>
        LONGDESC
        desc 'otadebug', 'Debug android device over the air'
        option :serial, :type => :string, :desc => 'Device serial', :required => false, :aliases => '-s'
        def otadebug
            target = get_target(options[:serial])
            ip = get_ipv4(target)
            say "Target ip: " + ip
            run "adb #{which_one(target)} tcpip 5555", :verbose => false
            run "adb #{which_one(target)} connect #{ip}", :verbose => false
        end

        long_desc <<-LONGDESC
        `logcat -s <serial>` will display logcat for specific device.

        Example:
        \x5> $ radb logcat -s 81f42e1
        \x5>
        LONGDESC
        desc 'logcat <package_name>', 'Display logcat for specific device'
        option :serial, :type => :string, :desc => 'Device serial', :required => false, :aliases => '-s'
        def logcat(package)
            target = get_target(options[:serial])
            if command?("logcat-color")
                puts "logcat-color is already exist"
                run "logcat-color #{which_one(target)} \"*:I\" | grep `adb shell ps | grep #{package} | cut -c10-15`", :verbose => false
            else
                puts "You should install `logcat-color` for better output"
                run "adb #{which_one(target)} logcat \"*:I\" | grep `adb shell ps | grep com.cloudjay.cjay | cut -c10-15`", :verbose => false
            end
        rescue
        end
    end
end
