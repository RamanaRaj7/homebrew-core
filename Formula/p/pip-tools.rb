class PipTools < Formula
  include Language::Python::Virtualenv

  desc "Locking and sync for Pip requirements files"
  homepage "https://pip-tools.readthedocs.io"
  url "https://files.pythonhosted.org/packages/1a/87/1ef453f10fb0772f43549686f924460cc0a2404b828b348f72c52cb2f5bf/pip-tools-7.4.1.tar.gz"
  sha256 "864826f5073864450e24dbeeb85ce3920cdfb09848a3d69ebf537b521f14bcc9"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa9da34f416d318a7c3a9526cfe69b1683cbc52c61a768c7935c29b7da7492ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa9da34f416d318a7c3a9526cfe69b1683cbc52c61a768c7935c29b7da7492ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa9da34f416d318a7c3a9526cfe69b1683cbc52c61a768c7935c29b7da7492ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "f52c7c1b06c27e8ca825371dc8ac46aa9ef4586e5196a2c876dc9c7170006cb0"
    sha256 cellar: :any_skip_relocation, ventura:       "f52c7c1b06c27e8ca825371dc8ac46aa9ef4586e5196a2c876dc9c7170006cb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "875deedf0324f719831864e1ccf1044da7752c1db9509777a99d2e2c1a6bef99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f038065823c2098303d0c13de5bedc7de731721ed2588762def4ea1da0c4bd37"
  end

  depends_on "python@3.13"

  resource "build" do
    url "https://files.pythonhosted.org/packages/7d/46/aeab111f8e06793e4f0e421fcad593d547fb8313b50990f31681ee2fb1ad/build-1.2.2.post1.tar.gz"
    sha256 "b36993e92ca9375a219c99e606a122ff365a760a2d4bba0caa09bd5278b608b7"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/e7/82/28175b2414effca1cdac8dc99f76d660e7a4fb0ceefa4b4ab8f5f6742925/pyproject_hooks-1.2.0.tar.gz"
    sha256 "1e859bd5c40fae9448642dd871adf459e5e2084186e8d2c2a79a824c970da1f8"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b7/a0/95e9e962c5fd9da11c1e28aa4c0d8210ab277b1ada951d2aee336b505813/wheel-0.44.0.tar.gz"
    sha256 "a29c3f2817e95ab89aa4660681ad547c0e9547f20e75b0562fe7723c9a2a9d49"
  end

  def install
    virtualenv_install_with_resources

    %w[pip-compile pip-sync].each do |script|
      generate_completions_from_executable(bin/script, shells: [:fish, :zsh], shell_parameter_format: :click)
    end
  end

  test do
    (testpath/"requirements.in").write <<~REQUIREMENTS
      pip-tools
      typing-extensions
    REQUIREMENTS

    compiled = shell_output("#{bin}/pip-compile requirements.in -q -o -")
    assert_match "This file is autogenerated by pip-compile", compiled
    assert_match "# via pip-tools", compiled
  end
end
