require "rspec"
require "webmock/rspec"
require "shoeboxed"

WebMock.disable_net_connect!

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Pathname.new(Dir.pwd).join("spec/support/**/*.rb")].each {|f| require f}
