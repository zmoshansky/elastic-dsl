# Elastic::Dsl

Elastic DSL is a highly modular gem to support simple dynamic construction of queries. It utilizes method chaining for query construction, a pattern similar to active record queries.

Once this has a bit more meat to it, I plan on submitting it to [elastic-search][1].

## Installation

Add this line to your application's Gemfile:

    gem 'elastic-dsl', git: 'git://github.com/zmoshansky/elastic-dsl'


And then execute:

    $ bundle

Or install it yourself as: [TODO - Add to Ruby Gems to enable the following functionality]

    $ gem install elastic-dsl

## Supported Functionality

### Queries
 - Boolean Queries (Nested as well)

### Filters
- Geo Distance Filters

## Usage

This gem is standalone and does not require rails or much of anything, it is pure ruby. Of course it works well with rails.

    require 'elastic-dsl'
    searcher = Elastic::DSL::SearchBuilder.new(base)
    searcher.must({match: {term: {name: 'frank'})
    elastic_search_query = searcher.es_query

searcher.es_query can now be passed to the Elasticsearch gem

    {
        query: {
            bool: {
                must => [ {match: {term: {name: 'frank'}}}]
            }
        }
    }

See the query and filter specs for more examples of how to use and create more complicated queries.

## Contributing

1. Fork it ( https://github.com/zmoshansky/elastic-dsl/fork )
2. Create your feature branch (`git checkout -b feature|bug/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull request


  [1]: https://github.com/elasticsearch