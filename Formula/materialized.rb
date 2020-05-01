class Materialized < Formula
  desc "The streaming data warehouse"
  homepage "https://materialize.io/docs/"
  url "https://github.com/MaterializeInc/materialize/archive/v0.2.1.tar.gz"
  sha256 "b5b3770008051186c9ce88e3ddd8da0f2d646cd95dd65545eb9758893a84279e"
  head "https://github.com/MaterializeInc/materialize.git"

  bottle do
    root_url "https://packages.materialize.io/homebrew"
    sha256 "b991256b3430cf0059c9745855d0e3f61a0f88b278f3fa04b23f8f57303e9fbc" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  STABLE_BUILD_SHA = "32d9f681749e7d9a417ea4ca730b3f3d7581c3a5".freeze

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
