class Mz < Formula
  desc "CLI for Materialize, the streaming database."
  homepage "https://materialize.com"
  license "Apache 2.0"

  depends_on "postgresql@14"

  VERSION = "0.1.0"

  if Hardware::CPU.arm?
    url "https://binaries.materialize.com/mz-v#{VERSION}-aarch64-apple-darwin.tar.gz"
    sha256 "945f63b3514279f334fca35d1ea078d71354d2ae57da42fe57af86c6d0866167"

    def install
      bin.install "bin/mz"
    end
  end
  if Hardware::CPU.intel?
    url "https://binaries.materialize.com/mz-v#{VERSION}-x86_64-apple-darwin.tar.gz"
    sha256 "06be949147015551657092d0da9a95fafeee6a3e4e87fd1a7fecc124c0646133"

    def install
      bin.install "bin/mz"
    end
  end

  test do
    system "#{bin}/mz --version"
  end
end
