# ChangeLog

V 0.0.3
 - [Feature] Added Tests for Errors
 - [Feature] one_of_these added to bool to do a nested should inside a must (great for categories)
 - [Feature] bool accepts an options[:filter] set to true to enable filtering
 - [Warning] bool moved to core module as it's used by a lot of things
 - **[Breaking Change]** Renamed Error base class to Error and moved to ../exceptions.rb

V 0.0.2
 - **[Breaking Change]** Interface for bool has changed to use an options hash, previously optional "root_node" arg is now {root: some_root}
 - **[Breaking Change]** SearchBuilder#node renamed to node?
 - [Feature] SearchBuilder#size() is available to set the size of the results from ES and is chainable
 - [Feature] SearchBuilder#size? is available to query the size of the results from ES
 - [BugFix] Elastic::DSL::Builders::Utils#find_node will return nil/false values if that's what the node maps to, previously it wrongly returned a NodeNotFound Error.
 - [Feature] More Tests!
 - [Warning] Queries::Bool - when used with nested `bool`s, it default to merging with the first `bool` added, this can cause problem if you're trying to query like (a || b) && (c || d). Use `options[:append] = true` and add at least one nested `bool` that doesn't have a `should`.

    {query:
        {bool:
          {must: [
            {bool:
              {should: [
                condition_a,
                condition_b,
              ]},
            },
            {bool:
              {should: [
                condition_c,
                condition_d,
              ]},
            },
          ]}
        }
      }

V 0.0.1
 - Due to rapid development of the initial features, the changelog will likely not reflect changes below v0.0.1.
