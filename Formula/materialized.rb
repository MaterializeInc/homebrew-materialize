class Materialized < Formula
  desc "The streaming data warehouse"
  homepage "https://materialize.io/docs/"
  url "https://github.com/MaterializeInc/materialize/archive/v0.1.0.tar.gz"
  version "v0.1.0"
  sha256 "2bf26562eb1f5eb20ff661781b07e4714a9a2f934d5131b3705a2ba15c558431"

  depends_on "rust" => :build
  # cmake is required for rdkafka because it depends on librdkafka
  depends_on "cmake" => :build

  BUILD_SHA = "07570f3658f57fceee43bb0fb38abbabedb92008"

  def install
    # Materialize uses a procedural macro that invokes "git" in order to embed
    # the current SHA in the built binary. The MZ_DEV_BUILD_SHA variable
    # blocks that macro from running at build-time.
    ENV["MZ_DEV_BUILD_SHA"] = BUILD_SHA
    system "cargo", "build", "--release", "--bin", "materialized"
    bin.install "target/release/materialized"
  end

  test do
    pid = fork do
      exec bin/"materialized"
    end
    sleep 2

    output = shell_output("curl 127.0.0.1:6875")
    assert_includes output, BUILD_SHA
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
