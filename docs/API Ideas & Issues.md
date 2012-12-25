API Ideas & Issues
==================

General Issues
--------------

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
* `user` isn't used anywhere else - should it be `created_by`?


Attachments
-----------


Blocking
--------

* There appears to be no way of getting the items blocked by a given item.
* When would `unblocked` ever be `true`?

Favorites
---------

* API docs are out of date; the data format is not even close.
