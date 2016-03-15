# OpalOrm

Welcome to OpalORM! OpalORM is a lightweight object-relational mapper for Ruby. With it you
can define a schema for your models, and then set up relations between them for easy access in your project.

Note: this gem is in its early stages and should not be trusted with important data. If you want stronger validations,
security, and more features, look no further than the library that inspired OpalORM: [ActiveRecord](https://github.com/rails/rails/tree/master/activerecord).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'opal_orm'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install opal_orm

In the root folder of your project, create a filed named `Rakefile` if you don't have one already.

Paste the following into your Rakefile:

```ruby
spec = Gem::Specification.find_by_name 'opal_orm'
load "#{spec.gem_dir}/lib/tasks/opal_db.rake"
```

## Usage

To start, run:

    $ opal_orm create

which will create an empty Sqlite database in ./db/opal.db.

Then, run:

    $ opal_orm generate SCHEMA_NAME TABLE1 TABLE2 ...

Where SCHEMA_NAME is the name of the new schema, TABLE1, TABLE2 etc. are the names
of the tables you'd like to generate. You can define more tables in the schema file if you
need to.

For example,

```ruby
create_table("table_name") do |t|
  t.integer :int_field
  t.string :string_field

  t.foreign_key :int_field
end
```

corresponds to

```sql
CREATE TABLE table_name (
  id INTEGER PRIMARY KEY,
  int_field INTEGER,
  string_field VARCHAR(255),

  FOREIGN KEY(int_field) REFERENCES table_name(id));
```

(The primary key column is generated automatically.)

Currently, the only supported column types are string and integer.

<!-- ## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org). -->

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nmatte/OpalORM.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
