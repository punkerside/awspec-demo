require 'awspec'

service_name = `cd examples/test/ && terraform output name`.strip.delete('"')

describe s3_bucket(service_name.to_s) do
  it { should exist }
end