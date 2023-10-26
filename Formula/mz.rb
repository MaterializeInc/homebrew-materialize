class Mz < Formula
  desc "CLI for Materialize, the streaming database."
  homepage "https://materialize.com"
  license "Apache 2.0"

  depends_on "postgresql@14"

  VERSION = "0.3.0"

  if Hardware::CPU.arm?
    url "https://binaries.materialize.com/mz-v#{VERSION}-aarch64-apple-darwin.tar.gz"
    sha256 "a158654cb27ae7014d0f10772f47b9c89ce51530a7a5b91f4da78d69faf8ba5e"

    def install
      bin.install "bin/mz"
    end
  end
  if Hardware::CPU.intel?
    url "https://binaries.materialize.com/mz-v#{VERSION}-x86_64-apple-darwin.tar.gz"
    sha256 "49a4de1207c70e6d132268b055b896304dac75dad178371a1d380619b170e943"

    def install
      bin.install "bin/mz"
    end
  end

  test do
    system "#{bin}/mz --version"
  end
end
