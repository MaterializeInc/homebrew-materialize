class Materialized < Formula
  desc "The streaming data warehouse"
  homepage "https://materialize.io/docs/"
  url "https://github.com/MaterializeInc/materialize/archive/v0.1.2.tar.gz"
  sha256 "937e2ee2f4ca81c718403b76375eba07b5fad5a9414b997599addb48ee17e25f"
  head "https://github.com/MaterializeInc/materialize.git"

  bottle do
    root_url "https://downloads.mtrlz.dev"
    sha256 "0fbc08b12926ec6408c38de5dcc6b9b960780d1bef020a98fd37b4a37fe7495a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  STABLE_BUILD_SHA = "c8a6eb384e06614ed9df837ddce48bd0c198383b".freeze

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
      exec bin/"materialized"
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
