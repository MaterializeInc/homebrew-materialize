class Materialized < Formula
  desc "The streaming data warehouse"
  homepage "https://materialize.io/docs/"
  url "https://github.com/MaterializeInc/materialize/archive/v0.4.1.tar.gz"
  sha256 "dc3979bf36f5fb953b9a89e231d74043704da7f9fc782319a2857c37648fac71"
  head "https://github.com/MaterializeInc/materialize.git", branch: "main"

  bottle do
    root_url "https://packages.materialize.io/homebrew"
    sha256 "42de97abaa0a3ac5335136d5f28daff2c242a5a56a1ce044f4d2d2f625f66b6f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  STABLE_BUILD_SHA = "dab1c09f17ab51bf3cadc092a5b7d8e214560511".freeze

  def build_sha
    if head?
      version.commit
    elsif stable?
      STABLE_BUILD_SHA
    else
      raise(FormulaSpecificationError, "sha for devel spec not specified")
    end
  end

  def install
    # Materialize uses a procedural macro that invokes "git" in order to embed
    # the current SHA in the built binary. The MZ_DEV_BUILD_SHA variable
    # blocks that macro from running at build-time.
    ENV["MZ_DEV_BUILD_SHA"] = STABLE_BUILD_SHA if stable?
    system "cargo", "install", "--locked",
                               "--root", prefix,
                               "--path", "src/materialized"
  end

  def caveats
    <<~EOS
      The launchd service will use only one worker thread. For improved
      performance, consider manually starting materialized and tuning the
      number of worker threads based on your hardware:
          materialized --threads=N
    EOS
  end

  plist_options manual: "materialized --threads=1"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/materialized</string>
          <string>--data-directory=#{var}/materialized</string>
          <string>--threads=1</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    pid = fork do
      exec bin/"materialized", "-w1"
    end
    sleep 2

    output = shell_output("curl 127.0.0.1:6875")
    assert_includes output, build_sha

    output = shell_output("materialized --version").chomp
    assert_equal output, "materialized v#{version} (#{build_sha})"
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
