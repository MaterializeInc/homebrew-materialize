class Mz < Formula
  desc "CLI for Materialize, the streaming database."
  homepage "https://materialize.com"
  license "Apache 2.0"

  depends_on "postgresql@14"

  VERSION = "0.1.2"

  if Hardware::CPU.arm?
    url "https://binaries.materialize.com/mz-v#{VERSION}-aarch64-apple-darwin.tar.gz"
    sha256 "670c1827f9eca5349487af84247040e84c5148ebebcab0d40da3bb932f7b2899"

    def install
      bin.install "bin/mz"
    end
  end
  if Hardware::CPU.intel?
    url "https://binaries.materialize.com/mz-v#{VERSION}-x86_64-apple-darwin.tar.gz"
    sha256 "6c3880c7c7bca8d51b8e434614fa1f1a627d2853645ddb67b4f2b1c0600fb46d"

    def install
      bin.install "bin/mz"
    end
  end

  test do
    system "#{bin}/mz --version"
  end
end
