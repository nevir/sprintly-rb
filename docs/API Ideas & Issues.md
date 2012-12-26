API Ideas & Issues
==================

General Issues
--------------

https://github.com/sprintly/sprint.ly-docs is out of date; the uservoice docs
seem to be more up to date.  Might want to kill off the github repo.

Some models embed their relationships while others don't; should be consistent.
It seems a bit odd to embed in some cases, though:

* When querying for attachments by item, that same item is embedded in every
  single attachment.  Might be better to just have `id` pointers.


Annotations
-----------

* Should include all annotations (comments, state changes, etc).
* Missing a date field.
* `id` is a misnomer, seems to be a sort index?
* Annotations do not embed the `item`.
* `user` should probably be `created_by`.


Attachments
-----------


Blocking
--------

* There appears to be no way of getting the items blocked by a given item.
* When would `unblocked` ever be `true`?


Deploys
-------

* Could really use a `created_at` (or `deployed_at`).
* `user` should probably be `deployed_by`.
* An `id` would be nice (consistent identity mapping throughout all models).
* The docs suggest that you get ALL deploys when hitting the `GET` endpoint.
  Considering each item is fully embedded, that is potentially a _lot_ of data
  and overhead w/o any sort of pagination!
* `notes` and `version` are only hinted at in the docs; not called out as
  supported params.


Favorites
---------

* API docs are out of date; the data format is not even close.
