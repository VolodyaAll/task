RSpec.shared_examples "returns true" do |method|
  it { expect(subject.public_send(method)).to be true }
end
