require_relative "custom_download_strategy.rb"

class SmithCli < Formula
  desc "Command line utility for interacting with Toolsmiths' pooled environments."
  homepage "https://github.com/pivotal/smith"
  version "v2.5.0"

  if OS.mac?
    url "https://github.com/pivotal/smith/releases/download/#{version}/smith_darwin_amd64.tar.gz", :using => CustomGitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "b2ab9d73bc1215e4a7d89fb525721ba4d33dc965148fef269ffd83253713fbce"
  elsif OS.linux?
    url "https://github.com/pivotal/smith/releases/download/#{version}/smith_linux_amd64.tar.gz", :using => CustomGitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "f7d88f7980081b79325b95fe5285b6446128638463b4a378221a2ae879df950d"
  end

  depends_on :arch => :x86_64

  def install
    bin.install "smith"
    (bash_completion/"smith").write <<-completion
# bash completion for Smith CLI
_complete_smith() {
  args=("${COMP_WORDS[@]:1:$COMP_CWORD}") # Skip first arg
  local IFS=$'\n' # Split into lines
  COMPREPLY=($(GO_FLAGS_COMPLETION=1 ${COMP_WORDS[0]} "${args[@]}"))
  return 0
}
complete -F _complete_smith smith
    completion
  end

  test do
    system "#{bin}/smith version"
  end
end
