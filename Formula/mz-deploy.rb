class MzDeploy < Formula
  desc "Declarative SQL project tooling for Materialize"
  homepage "https://materialize.com"
  version "0.3.0"
  license "BUSL-1.1"

  on_macos do
    on_arm do
      url "https://binaries.materialize.com/mz-deploy-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "4a689799d62c16dfa677e6a13ce9c4971bec844057b88866df2688698dfd9ebc"
    end
  end

  on_linux do
    on_intel do
      url "https://binaries.materialize.com/mz-deploy-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e56a4eb41f6cca9375c6a35cf3afb91f97a763b63090215023521e07a283e59d"
    end
    on_arm do
      url "https://binaries.materialize.com/mz-deploy-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "08a43e622c78ed35663995e16f25af543ff72866b45cbf345971fabe68220c31"
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
