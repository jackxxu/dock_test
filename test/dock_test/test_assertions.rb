require 'test_helper'

class TestAssertions < Minitest::Test

  include DockTest::Methods

  def test_assert_response_status_method
    get '/path?foo=bar', {a: :b}, {'CONTENT_TYPE' => 'application/json'}
    assert_response_status 200
  end

  def test_assert_response_content_type_method
    get '/path?foo=bar', {a: :b}, {'CONTENT_TYPE' => 'application/json'}
    assert_response_content_type 'application/json'
  end

  def test_assert_response_headers_method
    get '/path?foo=bar', {a: :b}, {'CONTENT_TYPE' => 'application/json'}
    assert_response_headers({"content-type"=>["application/json"]} , {exclude: ['content-length', 'server', 'connection', 'date', 'via', 'age']})
  end

  def test_assert_response_body_method
    skip unless ENV['DOCK_ENV'] == 'development'
    get '/path?foo=bar', {a: :b}, {'CONTENT_TYPE' => 'application/json'}
    assert_response_body '{"verb":"GET","uri":"http://localhost:9871/path?foo=bar&a=b","body":"","protcol":"HTTP/1.1","headers":{"ACCEPT":"*/*","USER_AGENT":"Ruby","CONTENT_TYPE":"application/json","HOST":"localhost:9871","VERSION":"HTTP/1.1"}}'
  end

  def test_assert_response_json_schema_method
    get '/path?foo=bar', {a: :b}, {'CONTENT_TYPE' => 'application/json'}
    assert_response_json_schema 'schemas/response.schema.json'
  end

  def test_assert_response_xml_schema_method
    get '/path?foo=bar', {a: :b}, {'CONTENT_TYPE' => 'application/xml'}
    assert_response_xml_schema 'schemas/response.schema.xsd'
  end
end
