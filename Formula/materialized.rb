class Materialized < Formula
  desc "Streaming SQL database powered by Timely Dataflow"
  homepage "https://materialize.io/docs/"
  url "https://github.com/MaterializeInc/materialize/archive/v0.26.5.tar.gz"
  sha256 "dd4d170ec5e800abc0b122ed832d0679751e17eab102012c1708301d026af4f3"

  disable! date: "2022-11-01", because: "is no longer supported to run Materialize locally. Get early access to the new cloud-native Materialize: https://materialize.com/materialize-cloud-access/"
end
