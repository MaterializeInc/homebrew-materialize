class Mz < Formula
  desc "CLI for Materialize, the streaming database."
  homepage "https://materialize.com"
  license "Apache 2.0"

  depends_on "postgresql@14"

  VERSION = "0.1.3"

  if Hardware::CPU.arm?
    url "https://binaries.materialize.com/mz-v#{VERSION}-aarch64-apple-darwin.tar.gz"
    sha256 "907bd4362e86fbbeb0640e96bf5fa008427ba06e0fffc61b788a628c4f49c0fd"

    def install
      bin.install "bin/mz"
    end
  end
  if Hardware::CPU.intel?
    url "https://binaries.materialize.com/mz-v#{VERSION}-x86_64-apple-darwin.tar.gz"
    sha256 "fb527e49ebb15e2c87d61ab4d00fcf290c625c082290e85a38ef3ee98aaa27ef"

    def install
      bin.install "bin/mz"
    end
  end

  test do
    system "#{bin}/mz --version"
  end
end
