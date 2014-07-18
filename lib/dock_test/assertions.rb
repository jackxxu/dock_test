module Minitest::Assertions
  def assert_response_status(status)
    assert last_response.code == status.to_s, "The response status is expected to be #{last_response.code}"
  end

  def assert_response_content_type(content_type)
    assert last_response['Content-Type'] == content_type.to_s, "The response content_type is expected to be #{last_response['Content-Type']}"
  end

  def assert_response_headers(headers, options = {})
    exclude_keys = Array(options[:exclude] || [])
    response_headers = last_response.to_hash.delete_if {|k, _| exclude_keys.include?(k)}
  end

  def assert_response_body(body_string)
    assert last_response.body == body_string, "The response body is expected to be #{last_response.body}"
  end

  def assert_response_json_schema(schema_path)
    schema = File.open(schema_path).read
    assert JSON::Validator.validate(schema, last_response.body), "The response is expected to have a schema defined in #{schema_path}"
  end
end
