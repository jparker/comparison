# [![Gem Version](https://badge.fury.io/rb/comparison.svg)](https://badge.fury.io/rb/comparison) [![Build Status](https://travis-ci.org/jparker/comparison.svg?branch=master)](https://travis-ci.org/jparker/comparison)

# Comparison

Comparison bundles up into Rails helpers the logic for rendering visually
informative comparisons of numbers. For example, say you were comparing the
sales figures from one quarter to the same quarter in a previous year. You
might want to show the percentage change, accompanied by an arrow or icon and
color-coded to indicate positive or negative growth. This plugin provides
helpers that abstract the logic of deciding what to show into a handful of
simple methods and leveraging I18n.

## Upgrade Notes

This gem has been getting a facelift, and this has resulted in some changes
from the old behavior.

`Comparison::Presenter#classes` has been renamed to
`Comparison::Presenter#dom_classes`, and `Comparison::Presenter#css` has been
renamed to `Comparison::Presenter#style`. The old method names continue to
work, but they will emit deprecation warnings.

The I18n keys used by the above methods have been similarly renamed, but the
methods will continue to fall back on the old keys. Going forward, use
`comparison.dom_classes` instead of `comparison.classes` and `comparison.style`
instead of `comparison.css`.

## Usage

The library has three components: the Comparison class for performing the
actual math, the Presenter class for decorating the Comparison with
view-friendly output, and a helper module for using the Presenter with the
view.

`#compare` helper takes the two numbers to be compared and yields the
Comparison presenter to a block.

`#difference` provides the absolute difference between the two numbers,
literally `m - n`.

`#percentage` provides the percentage difference between the two numbers. Under
the hood it uses `ActionView::Helpers::NumberHelper#number_to_percentage` to
format the percentage. Options are passed through to that method.

`#arrow` returns an HTML character entity for an arrow (up, down, or, for no
change, an empty string).

```erb
<%= compare m, n do |cmp| %>
  <td><%= number_to_currency m %></td>
  <td><%= number_to_currency n %></td>
  <td><%= cmp.difference %></td>
  <td>
    <%= cmp.arrow %>
    <%= cmp.percentage precision: 1 %>
  </td>
<% end %>
```

| Period  | Outcome | LY      | Diff     | Pct           |
| ------- | ------: | ------: | -------: | ------------: |
| Q4 2016 | $200.00 |  $50.00 | +$150.00 | &uarr;+300.0% |
| Q3 2016 | $125.00 | $100.00 |  +$25.00 |  &uarr;+25.0% |
| Q2 2016 | $100.00 | $125.00 |  -$25.00 |  &darr;-20.0% |
| Q1 2016 | $100.00 |   $0.00 | +$100.00 |        &uarr; |
| Q4 2015 | $75.00  |  $75.00 |    $0.00 |          0.0% |
| Q3 2015 | $0.00   |   $0.00 |    $0.00 |          0.0% |


## Configuration

Comparison uses I18n to configure the output of some of the Presenter methods.
Default implementations are provided where it makes sense. You can provide your
own implementations by adding translations to your application.

```yml
en:
  comparison:
    dom_classes:
      positive: 'comparison positive'
      negative: 'comparison negative'
      nochange: 'comparison nochange'
    style:
      positive: 'color: #3c763d; background-color: #dff0d8;'
      negative: 'color: #a94442; background-color: #f2dede;'
      nochange: 'color: #777777;'
    icons:
      positive_html: '<span class="glyphicon glyphicon-arrow-up"></span>'
      negative_html: '<span class="glyphicon glyphicon-arrow-down"></span>'
      nochange_html: '<span class="glyphicon glyphicon-minus"></span>'
    arrows:
      positive_html: '&uarr;'
      negative_html: '&darr;'
      nochange_html: ''
    infinity_html: '&infin;'
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'comparison'
```

And then execute:
```bash
$ bundle
```

Include the Comparison helpers by adding the following to your
application\_helper.rb:

```ruby
# app/helpers/application_helper.rb
module ApplicationHelper
  include Comparison::ApplicationHelper
end
```

## Contributing

Open an GitHub issue for problems and suggestions. This library is in its
infancy, so use it at your own risk.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
