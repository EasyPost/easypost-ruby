# frozen_string_literal: true

module EasyPost::InternalUtilities::System
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

  def self.ruby_version
    RUBY_VERSION
  end

  def self.ruby_patchlevel
    RUBY_PATCHLEVEL
  end

  def self.lib_version
    File.open(File.expand_path('../../VERSION', __dir__)).read.strip
  end
end
