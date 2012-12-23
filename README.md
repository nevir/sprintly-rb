Sprintly Client
===============

A Ruby client for [sprint.ly](https://sprint.ly)'s [API](http://help.sprint.ly/knowledgebase/topics/15784-api).


Developing the Gem
------------------

Nearly all of the dev concerns of `sprintly-rb` are managed via
[guard](https://github.com/guard/guard).  Just kick off `guard` in the
background, and it will take charge of running the tests and reloading them
whenever anything changes.

### Code Coverage

Strive for full code coverage!  You've got two ways of getting at it:

* Run `rake` or `rake coverage` - it will run the full test suite and open the
  coverage report in your browser (on OS X)

* Start guard in coverage mode via `COVERAGE=yes guard` and you will have
  partial coverage reports written with each test run.


License
-------

`sprintly-rb` is MIT licensed by Ian MacLeod.

[See the accompanying file](MIT-LICENSE.txt) for the full text.
