# Shoeboxed

A simple ruby client for the [Shoeboxed](http://shoeboxed.com) [API](http://developer.shoeboxed.com).

## Installation

```bash
$ gem install shoeboxed
```

Or include it in your Gemfile:

```ruby
gem "shoeboxed"
```

For the bleeding edge reference this repository:

```ruby
gem "shoeboxed", :git => "https://github.com/jonmagic/shoeboxed"
```

## Usage

You will need to [signup](https://app.shoeboxed.com/landing/registration3.htm) for a Shoeboxed account and then [request a token](https://app.shoeboxed.com/member/account-api-keys.htm) at which point you will be given an ```api_user_token```.

### Authentication

After signing up for an account and requesting a token you will need to use the app name you specified while requesting the token to create an authentication_url.

In addition you will need to add an endpoint to your application that Shoeboxed can hit (similar to the Oauth process) in order to retrieve your sbx_user_token.

> NOTE: I have created an [example implementation] for connecting to Shoeboxed and getting the sbx_user_token.

#### Creating an sbx_user_token

Armed with the app name and callback url you can generate an authentication url:

```ruby
> :app_name => "Woot!",
  :callback_url => "http://foo.bar/shoeboxed/callback"
=> "https://api.shoeboxed.com/v1/ws/api.htm?SignIn=1&appname=Hoyt+Accounting&appurl=http%3A%2F%2Ffoo.bar%2Fshoeboxed%2Fcallback&appparams="
```

#### Finally

Once you have your api_user_token and sbx_user_token life is easy. Create a new instance of the Shoeboxed client passing it both tokens in an options hash.

```ruby
> shoeboxed = Shoeboxed.new(:api_user_token => "foo", :sbx_user_token => "bar")
=> #<Shoeboxed...>
```

### Upload

You can upload documents and images to Shoeboxed for storage and processing. Receipts and business cards will be processed and their details stored for easy access via the API.

In this example the document is a receipt image. The guid, or unique id, is used to reference the uploaded document. In this example I use SimpleUUID to generate the guid but please note that SimpleUUID is not included when you install the shoeboxed gem.

```ruby
> document = File.open("receipt.jpg")
> guid = SimpleUUID::UUID.new.to_guid
> shoeboxed.upload(document, :receipt, guid)
=> true
```

### Document Status

Get document status by guid. If you passed a unique id (guid) to the upload method when uploading the document you can later look it up by that guid to see whether it has finished processing, what type of document it is, and get the Shoeboxed document id (needed for making single API request to get the document details).

```ruby
> shoeboxed.status("033c9fa8-c335-11e2-9172-dc397603307a")
=> {:document_type => "Receipt", :document_id => 67789, :status => "DONE"}
```

### Receipts

You can find a receipt by the unique id (guid) passed in during upload or by it's Shoeboxed id.

#### find_by_guid

This method of finding a receipt requires two requests, the first to get the status of the receipt and the second to retrieve the receipt by it's Shoeboxed id.

If the receipt has not finished processing find_by_guid will return ```nil```:

```ruby
> shoeboxed.receipts.find_by_guid("033c9fa8-c335-11e2-9172-dc397603307a")
=> nil
```

Once it has finished processing it will return a Shoeboxed::Receipt instance:

```ruby
> shoeboxed.receipts.find_by_guid("033c9fa8-c335-11e2-9172-dc397603307a")
=> #<Shoeboxed::Receipt...>
```

#### find_by_id

Finding the receipt by it's Shoeboxed id only requires one request.

If the receipt is found it will return a Shoeboxed::Receipt instance:

```ruby
> shoeboxed.receipts.find_by_id(1234)
=> #<Shoeboxed::Receipt...>
```

If the receipt is not found an error is raised:

```ruby
> shoeboxed.receipts.find_by_id(4321)
Shoeboxed::Document::NotFound: document with id '4321' not found
```

#### all

Getting a list of receipts filtered by criteria is simple. You can filter by category_id and modified_since as well as limit the number of results per page and select which page you want to retrieve.

Limit defaults to 100 and not setting a page will return all receipts from all pages.

```ruby
> shoeboxed.receipts.all \
  :category_id => 234567,
  :limit => 50,
  :modified_since => 1.day.ago,
  :page => 2
=> [#<Shoeboxed::Receipt...>, #<Shoeboxed::Receipt...>, ...]
```

## License

See [LICENSE] for details.
