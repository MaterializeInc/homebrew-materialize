class Materialized < Formula
  desc "Streaming SQL database powered by Timely Dataflow"
  homepage "https://materialize.io/docs/"
  url "https://github.com/MaterializeInc/materialize/archive/v0.7.1.tar.gz"
  sha256 "972386c4398075d141665c52c26a0f46c84c29182dbc6a48185e3913060026ab"
  head "https://github.com/MaterializeInc/materialize.git", branch: "main"

  bottle do
    root_url "https://packages.materialize.io/homebrew"
    sha256 "f23141dad1fa82daedeee38f439f03db59d34572a872950b3693a9f81a34eab0" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  STABLE_BUILD_SHA = "f4bd159fa73d37d44f8ed3f1db13c0c2ff85566f".freeze

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
    assert_equal output, "materialized v#{version} (#{build_sha[0...9]})"
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
