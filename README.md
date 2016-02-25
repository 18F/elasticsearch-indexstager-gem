# elasticsearch-indexstager RubyGem

[![Build Status](https://travis-ci.org/18F/elasticsearch-indexstager-gem.svg?branch=master)](https://travis-ci.org/18F/elasticsearch-indexstager-gem)

Elasticsearch index management, for stage/promote pattern.

See also:

* [elasticsearch-rails-ha](https://github.com/18F/elasticsearch-rails-ha)

## Examples

A busy ES installation needs to stay up and serving requests. If you need to build a new index,
you can "stage" it alongside the live index, and then "promote" the stage to be live. This allows
for zero downtime cutovers of new indices.

```ruby
require 'elasticsearch'
require 'elasticsearch/index_stager'

client = Elasticsearch::Client.new log: true
stager = Elasticsearch::IndexStager.new(index_name: 'foo', es_client: client)

client.index(index: stager.tmp_index_name, type: 'article', id: 1, body: { title: 'Test' })
stager.alias_stage_to_tmp_index

results = client.search(index: stager.stage_index_name, body: { query: { match: { title: 'test' } } })
stager.promote
results = client.search(index: stager.index_name, body: { query: { match: { title: 'test' } } })
```

## Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0
> dedication. By submitting a pull request, you are agreeing to comply
> with this waiver of copyright interest.
