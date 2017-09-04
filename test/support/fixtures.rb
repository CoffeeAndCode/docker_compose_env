module Fixtures
  class << self
    attr_accessor :file_fixture_path
  end

  def file_fixture(fixture_name)
    path = Pathname.new(File.join(Fixtures.file_fixture_path, fixture_name))

    if path.exist?
      path
    else
      msg = "The directory '%s' does not contain a file named '%s'."
      raise ArgumentError, format(msg, Fixtures.file_fixture_path, fixture_name)
    end
  end
end
