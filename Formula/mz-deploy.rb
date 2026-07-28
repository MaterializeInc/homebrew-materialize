class MzDeploy < Formula
  desc "Declarative SQL project tooling for Materialize"
  homepage "https://materialize.com"
  version "0.3.1"
  license "BUSL-1.1"

  on_macos do
    on_arm do
      url "https://binaries.materialize.com/mz-deploy-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "5c5f1867d99daec929cded6a60e5eb7c01cd028dba4a37f7c004979cbf5580b8"
    end
  end

  on_linux do
    on_intel do
      url "https://binaries.materialize.com/mz-deploy-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fdbba85d6cf8cd57e9b3ad60a00f657b23680d0ac4abbf642c6feb5307dfe7b3"
    end
    on_arm do
      url "https://binaries.materialize.com/mz-deploy-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "37685d6a2f7a494a9526ac11d01efc05f29481324ba7d01d0604e3d76ec793f4"
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
