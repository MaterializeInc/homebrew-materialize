class MzDeploy < Formula
  desc "Declarative SQL project tooling for Materialize"
  homepage "https://materialize.com"
  version "0.8.0"
  license "BUSL-1.1"

  on_macos do
    on_arm do
      url "https://binaries.materialize.com/mz-deploy-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "4979feef01715592ef915bdfa702f8cdeb8724d1a005af27d25fcf25e0bd2dc8"
    end
  end

  on_linux do
    on_intel do
      url "https://binaries.materialize.com/mz-deploy-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "57f743c4fe58356e5922003d5e6f3887853670384570e2648af7c2778086a170"
    end
    on_arm do
      url "https://binaries.materialize.com/mz-deploy-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "17d03e1f8b4e698107bbaaffb218baa3b862b0d946fa79aec8d2bf85c374a559"
    end
  end

  def install
    bin.install "bin/mz-deploy" => "mz-deploy"
    generate_completions_from_executable(bin/"mz-deploy", "completions", shells: [:bash, :zsh, :fish])
  end

  test do
    system "#{bin}/mz-deploy", "--version"
  end
end
