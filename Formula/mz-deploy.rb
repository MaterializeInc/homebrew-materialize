class MzDeploy < Formula
  desc "Declarative SQL project tooling for Materialize"
  homepage "https://materialize.com"
  version "0.6.0"
  license "BUSL-1.1"

  on_macos do
    on_arm do
      url "https://binaries.materialize.com/mz-deploy-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "084995c7d49dc31b9ae42469002a7a480d8c6bf9b1033f91016a6e5e81f9c4eb"
    end
  end

  on_linux do
    on_intel do
      url "https://binaries.materialize.com/mz-deploy-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "56c250704e1a527e239d1c17dd3a1a61f3752a26a78f41612956b5bcb433ef35"
    end
    on_arm do
      url "https://binaries.materialize.com/mz-deploy-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "350bd1d1de00a91bd128b92803ae0f53fde4dd4b1b3d5fa8ddc465310dd3c820"
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
