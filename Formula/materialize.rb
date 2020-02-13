class Materialize < Formula
  desc "Official Materialize command-line interface"
  homepage "https://materialize.io/docs/"
  url "https://github.com/MaterializeInc/materialize/archive/v0.1.0.tar.gz"
  version "v0.1.0"
  sha256 "43de4b569f4a377529287bf7b3a62e6b000f307617cbc9463dda425ba7b6d2dc"

  depends_on "rust" => :build
  # cmake is required for rdkafka because it depends on librdkafka
  depends_on "cmake" => :build

  def install
    # Materialize uses a procedural macro that invokes "git" in order to embed
    # the current SHA in the built binary. The MZ_DEV_BUILD_SHA variable
    # blocks that macro from running at build-time.
    ENV['MZ_DEV_BUILD_SHA'] = "07570f3658f57fceee43bb0fb38abbabedb92008"
    system "cargo", "build", "--release", "--bin", "materialized"
    bin.install "target/release/materialized"
  end

  test do
    # todo: Write a better test!
    system "#{bin}/materialized", "--version"
  end
end
