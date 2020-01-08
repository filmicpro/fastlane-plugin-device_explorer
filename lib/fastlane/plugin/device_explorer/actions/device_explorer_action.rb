require 'fastlane/action'
require_relative '../helper/device_explorer_helper'

class Device
  attr_reader :name, :id
  def initialize(name, id)
    @name = name
    @id = id
  end

  def to_s
    "#{@name} - #{@id}"
  end
end

module Fastlane
  module Actions
    class DeviceExplorerAction < Action
      def self.run(params)
        UI.message("Searching for connected devices")
        # throw out all Simulators to make the next Regex easier
        s = `instruments -s`.split("\n").select { |l| !l.include?("Simulator") }
        # m is an array of MatchData with a match on the device name and id
        m = s.map { |l| l.match(/^(.+)\s+\(\d+\.\d+.*\)\s\[(.*)\].*$/) }.select { |n| n }
        # devices = m.map { |k| k.captures.first } # just the names
        results = []
        m.each do |r|
          if 2 == r.captures.count
            results.push(Device.new(r.captures[0], r.captures[1]))
          end
        end
        UI.message("Found #{results.count} connected devices")
        results
      end

      def self.description
        "Detect connect iOS devices"
      end

      def self.authors
        ["Seth Faxon"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Returns the devices currently connected."
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "DEVICE_EXPLORER_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        [:ios, :mac].include?(platform)
      end
    end
  end
end
