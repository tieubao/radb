require 'highline/import'
require 'configliere'
require 'fileutils'
require 'childprocess'
require 'tempfile'
require 'date'

module Radb

    attr_reader :last_stdout, :last_stderr

    CONFIG_FILE = File.expand_path("~/.badb_config.yaml")

    def adb_path
        return @adb_path if @adb_path
        @adb_path = `which adb`.strip
        if @adb_path.empty?
            raise "Can't find your adb command. Is your path set\?"
        end
        @adb_path
    end

    def get_devices
        devices = []
        IO.popen("#{adb_path} devices").each_line do |line|
            line = line.strip
            if line =~ /^(.*)\tdevice$/
                devices << $1
            end
        end
        devices
    end

    def get_target(serial)

        if serial
            device = serial
        else
            device = choose_device
        end

        if device.nil?
            raise "Device not found"
        end

        target = { :serial => device }
        return target
    end

    def which_one(target)
        direct = ''
        direct = '-d' if target[:device]
        direct = '-e' if target[:emulator]
        direct = "-s #{target[:serial]}" if target[:serial]
        direct
    end

    def get_ipv4(target={})

        lines = %x(adb #{which_one(target)} shell ip -f inet addr show wlan0)
        lines.each_line do |line|
            line.strip
            if line =~ /inet (.*)\/24/
                return $1
            end
        end

    end

    def choose_device()
        devices = get_devices

        if devices.empty?
            raise "No devices attached"

        elsif devices.size == 1
            # yield devices[0] if block_given?
            return devices[0]
        else
            choose do |menu|
                menu.prompt = "Choose your adb device: "
                devices.each do |device|
                    menu.choice device do
                        # yield device if block_given?
                        return device
                    end
                end
            end
        end
    end

    def current_device

        devices = get_devices
        return devices[0] if devices.size == 1
        return nil
    end

    def list_devices
        devices = get_devices

        puts "List of devices: "
        devices.each do |d|
            puts d
        end
    end

    #
    def execute_adb_with(timeout, arguments)
        args = arguments.split
        execute_adb_with_exactly timeout, *args
    end

    def execute_adb_with_exactly(timeout, *arguments)

        process = ChildProcess.build('adb', *arguments)
        process.io.stdout, process.io.stderr = std_out_err
        process.start

        kill_if_longer_than(process, timeout)
        @last_stdout = output(process.io.stdout)
        @last_stderr = output(process.io.stderr)
    end

    def wait_for_device(target={}, timeout=30)
        execute_adb_with(timeout, "#{which_one(target)} wait-for-device")
    end
end
