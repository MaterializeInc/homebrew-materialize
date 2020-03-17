class Materialized < Formula
  desc "The streaming data warehouse"
  homepage "https://materialize.io/docs/"
  url "https://github.com/MaterializeInc/materialize/archive/v0.1.3.tar.gz"
  sha256 "23aa89b464a69cb143372adbd7efe6e04fe5982d0964d357a9d9890854a2c66e"
  head "https://github.com/MaterializeInc/materialize.git"

  bottle do
    root_url "https://downloads.mtrlz.dev"
    sha256 "a14fb6a49a4f5e52e08ea37e02f0abf7f35889f92ba33017e428fbeac41fca20" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  STABLE_BUILD_SHA = "ac35436462038fbac2b65f6ca020553a4cbef60d".freeze

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
