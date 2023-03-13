class Mz < Formula
  desc "CLI for Materialize, the streaming database."
  homepage "https://materialize.com"
  license "Apache 2.0"

  depends_on "postgresql@14"

  VERSION = "0.1.0"

  if Hardware::CPU.arm?
    url "https://binaries.materialize.com/mz-v#{VERSION}-aarch64-apple-darwin.tar.gz"
    sha256 "e8cd094f24b3014b98cb21072e84263c820d3e03079498ecfa3f3fa403b18e8e"

    def install
      bin.install "bin/mz"
    end
  end
  if Hardware::CPU.intel?
    url "https://binaries.materialize.com/mz-v#{VERSION}-x86_64-apple-darwin.tar.gz"
    sha256 "676b70c3b071f3d183900cba694a30bf8351596e556b91002117b14cf4b6fc4f"

    def install
      bin.install "bin/mz"
    end
  end

  test do
    system "#{bin}/mz --version"
  end
end
