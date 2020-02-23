class Materialized < Formula
  desc "The streaming data warehouse"
  homepage "https://materialize.io/docs/"
  url "https://github.com/MaterializeInc/materialize/archive/v0.1.1.tar.gz"
  sha256 "42e6a7d32615e3097ec50ba644ae6d47ead87ac58fb0bf5eb29da977614511b9"
  head "https://github.com/MaterializeInc/materialize.git"

  bottle do
    root_url "https://downloads.mtrlz.dev"
    sha256 "7b9cfe7a816cbda450ca4b0435c1481a72d4a81a2b59a878588132a288afc581" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  STABLE_BUILD_SHA = "2cbdedae2c98f239682c59b450d6f16960e3b827".freeze

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
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
