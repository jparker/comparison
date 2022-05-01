# 0.2.0

* Deprecated `Comparator#m` and `Comparator#n`. Use `Comparator#value` and
  `Comparator#other` instead.
* Deprecated `Comparator#absolute` and `Comparator#relative`. Use
  `Comparator#difference` and `Comparator#percentage` instead.
* Added `Comparator#change`
* Deprecated `Presenter#style`. Use `Presenter#inline_style` instead.
* Deprecated `Presenter#difference`. Use `Presenter#difference_as_currency`
  instead.
* Added `Presenter#unsigned_percentage`.
* Support Rails through 6.x.
* Target Ruby 2.7 through Ruby 3.1 for testing.
