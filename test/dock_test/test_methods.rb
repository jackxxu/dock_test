require 'test_helper'

class TestMethods < Minitest::Test

  include DockTest::Methods

  def test_get_method_with_hash_body
    get '/path?foo=bar', {a: :b}, {'CONTENT_TYPE' => 'application/json'}

    assert_equal last_response_json['uri'], "#{DockTest.url}/path?foo=bar&a=b"
    assert_equal last_response_json['verb'], 'GET'
    assert_equal last_response_json['body'], ''
    assert_equal last_response_json['headers']['CONTENT_TYPE'], 'application/json'
  end

  def test_get_method_with_string_body
    get '/path?foo=bar', 'a=b', {'CONTENT_TYPE' => 'application/json'}

    assert_equal last_response_json['uri'], "#{DockTest.url}/path?foo=bar&a=b"
    assert_equal last_response_json['verb'], 'GET'
    assert_equal last_response_json['body'], ''
    assert_equal last_response_json['headers']['CONTENT_TYPE'], 'application/json'
  end

  def test_get_method_to_root
    get '/', 'a=b', {'CONTENT_TYPE' => 'application/json'}

    assert_equal last_response_json['uri'], "#{DockTest.url}/?a=b"
    assert_equal last_response_json['verb'], 'GET'
    assert_equal last_response_json['body'], ''
    assert_equal last_response_json['headers']['CONTENT_TYPE'], 'application/json'
  end

  def test_post_method
    post '/path?foo=bar', MultiJson.dump({guid: '12345'}), {'CONTENT_TYPE' => 'application/json'}

    assert_equal last_response_json['uri'], "#{DockTest.url}/path?foo=bar"
    assert_equal last_response_json['verb'], 'POST'
    assert_equal last_response_json['body'], "{\"guid\":\"12345\"}"
    assert_equal last_response_json['headers']['CONTENT_TYPE'], 'application/json'
  end

  def test_put_method
    put '/path?foo=bar', MultiJson.dump({guid: '12345'}), {'CONTENT_TYPE' => 'application/json'}

    assert_equal last_response_json['uri'], "#{DockTest.url}/path?foo=bar"
    assert_equal last_response_json['verb'], 'PUT'
    assert_equal last_response_json['body'], "{\"guid\":\"12345\"}"
    assert_equal last_response_json['headers']['CONTENT_TYPE'], 'application/json'
  end

  def test_patch_method
    patch '/path?foo=bar', MultiJson.dump({guid: '12345'}), {'CONTENT_TYPE' => 'application/json'}

    assert_equal last_response_json['uri'], "#{DockTest.url}/path?foo=bar"
    assert_equal last_response_json['verb'], 'PATCH'
    assert_equal last_response_json['body'], "{\"guid\":\"12345\"}"
    assert_equal last_response_json['headers']['CONTENT_TYPE'], 'application/json'
  end

  def test_delete_method
    delete '/path?foo=bar', '', {'CONTENT_TYPE' => 'application/json'}

    assert_equal last_response_json['uri'], "#{DockTest.url}/path?foo=bar"
    assert_equal last_response_json['verb'], 'DELETE'
    assert_equal last_response_json['body'], ''
    assert_equal last_response_json['headers']['CONTENT_TYPE'], 'application/json'
  end

  def test_accept_header_nil
    get '/', '', {'Accept' => nil, 'CONTENT_TYPE' => 'application/json'}
    assert_equal last_response_json['headers']['ACCEPT'], nil
  end

  private
    def last_response_json
      MultiJson.load(last_response.body)
    end
end

