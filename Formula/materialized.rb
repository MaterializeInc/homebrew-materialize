class Materialized < Formula
  desc "Streaming SQL database powered by Timely Dataflow"
  homepage "https://materialize.io/docs/"
  url "https://github.com/MaterializeInc/materialize/archive/v0.9.1.tar.gz"
  sha256 "3f815a00c88d8bad89bb894d9faca6ac9f4c57bdd4a612be58c51ddb7c83edfc"
  head "https://github.com/MaterializeInc/materialize.git", branch: "main"

  bottle do
    root_url "http://homebrew.materialize.com"
    sha256 high_sierra: "ad67c5cdbd3138a4b2c5ae4e098e57a130e577b272e057ef03a9c9cdc5b2457b"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  STABLE_BUILD_SHA = "ca7a34c645a445d6e2bd3c64101fe4da2c4a7dd5".freeze

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
          materialized --workers=N
    EOS
  end

  plist_options manual: "materialized --workers=1"

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
          <string>--workers=1</string>
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
    assert_equal output, "materialized v#{version} (#{build_sha[0...9]})"
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
