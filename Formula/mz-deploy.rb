class MzDeploy < Formula
  desc "Declarative SQL project tooling for Materialize"
  homepage "https://materialize.com"
  version "0.1.0"
  license "BUSL-1.1"

  on_macos do
    on_arm do
      url "https://binaries.materialize.com/mz-deploy-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "94d6f745b9a9d0180cc6194109753f99e7b3374facb7d41d1916476bf9a1566c"
    end
  end

  on_linux do
    on_intel do
      url "https://binaries.materialize.com/mz-deploy-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "673d1980d74b62a6e1e0a6cd7430aebd803d47903c2ef1198ca3532d4f14c49f"
    end
    on_arm do
      url "https://binaries.materialize.com/mz-deploy-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d3b4c28ce4d9a215416153af8aaec12fea4c668975b70f878be4efd498a530d6"
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
