class Mz < Formula
    version '0.0.0'
    desc "Command-line interface (CLI) for Materialize."
    homepage "https://materialize.io/docs/"
    url "https://github.com/MaterializeInc/materialize/archive/refs/tags/v0.27.0-alpha.22.tar.gz"
    sha256 "5cc8bcbe2643fc48a08f853e13efe005c3f9f357b66c51ac428be6271d896500"
    head "https://github.com/MaterializeInc/materialize.git", branch: "main"

    bottle do
        root_url "http://homebrew.materialize.com"
        sha256 arm64_big_sur: "TBD"
        sha256 mojave: "TBD"
    end

    depends_on "cmake" => :build
    depends_on "rust" => :build
    depends_on "libpq" => :build

    def install
        system "cargo", "install", "--locked",
                                   "--root", prefix,
                                   "--path", "src/mz"
    end
end