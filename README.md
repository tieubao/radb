# Radb

Radb is a gem that provide cli for some adb tasks in android device. It required `adb` for adb command set and `logcat-color` for better logcat output.

## Installation

### On Mac OSX

Install xcode command-line tool:

    `$ xcode-select --install`

Install `adb`:

    `$ bash <(curl https://raw.github.com/corbindavenport/nexus-tools/master/install.sh)`

Install `python, pip, ruby` through `homebrew`

Install `logcat-color` through `pip`

Install it yourself as:

    `$ gem install radb`

## Usage

    At this version, `radb` provides 4 commands:

    `$ radb pull <package>`: pull database and images data from app to PC
    Example:
        $ radb pull com.cloudjay.cjay -d cjay.db -i CJay
        $ radb pull com.cloudjay.cjay -d cjay.db -i CJay -s <device serial>

    `$ radb push <package>`: push database and images from PC to app
    Example:
        $ radb push com.cloudjay.cjay -d cjay.db -i CJay
        $ radb push com.cloudjay.cjay -d cjay.db -i CJay -s <device serial>

    `$ radb logcat <package>`: display logcat for specific app
    Example:
        $ radb logcat com.cloudjay.cjay
        $ radb logcat com.cloudjay.cjay -s <device serial>

    `$ radb otadebug`: enable ota debugging for android device.
    Example:
        $ radb otadebug
        $ radb otadebug -s <device serial>

## Contributing

1. Fork it ( https://github.com/tieubao/radb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
