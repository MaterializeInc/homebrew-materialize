class Materialize < Formula
  desc "Official Materialize command-line interface"
  homepage "https://materialize.io/docs/"
  url "https://homebrew-materialize.s3.us-east-2.amazonaws.com/materialize.tar.gz"
  version "beta"
  sha256 "d3cd6a36a7e8444ae2e421b960d8044a3d4f15292e0eb4ab77fdb6fab4eb0ac2"

  depends_on "rust" => :build
  # cmake is required for rdkafka because it depends on librdkafka
  depends_on "cmake" => :build

  def install
    # Materialize uses a procedural macro that invokes "git" in order to embed
    # the current SHA in the built binary. The MZ_DEV_BUILD_SHA variable
    # blocks that macro from running at build-time.
    ENV['MZ_DEV_BUILD_SHA'] = "d3cd6a36a7e8444ae2e421b960d8044a3d4f15292e0eb4ab77fdb6fab4eb0ac2"
    system "cargo", "build", "--release", "--bin", "materialized"
    bin.install "target/release/materialized"
  end

  test do
    # todo: Write a better test!
    system "#{bin}/materialized", "--version"
  end
end
