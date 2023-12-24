# frozen_string_literal: true

dir = __dir__
Dir["#{dir}/shared_examples/**/*.rb"].sort.each { |f| require f }

def verify_exact_contents(subject, title, expected_lines)
  content = subject.resource('file', title).send(:parameters)[:content]
  expect(content.split("\n").reject { |line| line =~ %r{(^$|^#)} }).to eq(expected_lines)
end
