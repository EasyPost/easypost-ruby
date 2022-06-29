# frozen_string_literal: true

# Retrieve operating system information
module EasyPost::VersionInfo
  attr_accessor :os_name, :os_version, :os_arch

  def self.os_name
    case RUBY_PLATFORM
    when /linux/i
      'Linux'
    when /darwin/i
      'Darwin'
    when /cygwin|mswin|mingw|bccwin|wince|emx/i
      'Windows'
    else
      'Unknown'
    end
  end

  def self.os_version
    Gem::Platform.local.version
  end

  def self.os_arch
    Gem::Platform.local.cpu
  end
end
