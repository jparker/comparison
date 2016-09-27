# Comparison

I have often found myself implementing reporting features that compare two
numbers to each other. For example, a report that compares the outcome for a
quarter to the outcome of the same quarter in the prior year. Frequently I end
up displaying both the raw difference between the two numbers, the percentage
difference, and maybe a simple visual indicator such as an arrow (pointing up
or down). Sometimes these comparisons require special handling for Infinity and
NaN when one or both numbers are zero.

I've tackled this task enough times and in enough applications that I felt it
would simplify my life to extract and package the code for future re-use.

## Usage
The library has three components: the Comparison class for performing the
actual math, the Presenter class for decorating the Comparison with
view-friendly output, and a helper module for using the Presenter with the
view.

The `#compare` helper takes the two numbers to be compared and yields the
Comparison presenter to a block.

The `#difference` method provides the absolute difference between the two
numbers, literally `m - n`.

The `#percentage` method provides the percentage difference between the two
numbers. It uses `#number_to_percentage` under the hood, and passes options
through.

The `#arrow` method returns an HTML character entity for an arrow (up, down,
or, for no change, an empty string).

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
TODO: Write more about I18n.

```yml
en:
  comparison:
    arrows:
      positive_html: '&uarr;'
      negative_html: '&darr;'
      nochange_html: ''
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

Or install it yourself as:
```bash
$ gem install comparison
```

## Contributing
Open an GitHub issue for problems and suggestions. This library is in its
infancy, so use it at your own risk.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
