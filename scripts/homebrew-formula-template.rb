class Swiftanvil < Formula
  desc "Swift project scaffolding with architectural enforcement"
  homepage "https://github.com/swiftanvil/swiftanvil-cli"
  url "https://github.com/swiftanvil/swiftanvil-cli/archive/refs/tags/{{TAG}}.tar.gz"
  sha256 "{{SHA256}}"
  license "MIT"

  depends_on xcode: ["16.0", :build]
  depends_on macos: :sonoma

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/iFoundation"
  end

  test do
    system "#{bin}/iFoundation", "--version"
  end
end
