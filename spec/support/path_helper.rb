module PathHelper
  # Public: Root path.
  #
  # Returns a Pathname.
  def project_root_path
    Pathname.new(Dir.pwd)
  end

  # Public: Path to fixture.
  #
  # name      - Name of file without extension.
  # extension - File extension, defaults to xml.
  #
  # Returns a Pathname.
  def fixture_path(name, extension="xml")
    project_root_path.join("spec", "fixtures", "#{name}.#{extension}")
  end

  RSpec.configure do |config|
    config.include(self)
  end
end
