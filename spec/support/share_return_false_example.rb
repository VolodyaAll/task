RSpec.shared_examples "returns false" do |method|
  it { expect(subject.public_send(method)).to be false }
end
