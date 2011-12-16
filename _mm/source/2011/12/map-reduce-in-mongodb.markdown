--- 
title: Map Reduce in Mongo Mapper
date: 08/Dec/2011
tags: [ ruby, rails, software, object container ]
---

[Horizon's][hr] object container infrastructure is designed to provide a structure agnostic cloud back end service for a range of [Horizon's][hr] projects.  We're using mongoDb through [Mongo Mapper][mm] and generally it's pretty good.
![Mongo Mapper](/img/mongomapper.png){: .rightimg} but there is no mention at all on the Mongo Mapper website of map reduce, which, to my mind, is odd.

Thankfully Google is our Friend, and [this blog post](http://www.chrisumbel.com/article/map_reduce_mongodb_mongomapper_rails) from Chris Umbel shows the way.

Here are the key things that you need to know:

You have a MongoDb database model class that wraps access to MongoDb- This is the class that includes

    :::ruby
    include MongoMapper::Document

It probably looks something like

    :::ruby
    require 'mongo_mapper'

    class MySchemalessModelClass
      include MongoMapper::Document

      key :mytype, Integer
      timestamps!

      ensure_index [[:mytype,1], [_id,1]]
      ....
    end

With this class you can create an object with new and a hash which must include the key called `:type`.  Other keys of arbitrary type will be accepted and stored (with a call to `save!` for example).

The class has it's connection to MongoDb and the collection that it accesses are both defined in `RAILS_ROOT/config/mongo.yml`.  MongoMapper mixes in methods for find, validation and so on that allow an interface somewhat like rails ActiveRecord.

`MySchemalessModelClass` includes methods `db` and `collection` which gives access to the database and collection objects associated respectively with the class.  Map-reduce is not provided at the wrapper class's document interface directly but through the collection. This means calling something like

    :::ruby
    MySchemalessModelClass.collection.map_reduce(map, reduce, 
        :query => {}, :out => {:inline=>true}, :raw => true)

One gotcha is that `map_reduce` now requires you to specify an output collecion name (previously it would invent one if you didn't privide and `:out` to the options hash.  Here I specify `:inline` which devlivers the results in the return value (and requires `:raw=>true`. Should you omit `:out` you will get an error that looks like this...

    :::ruby
    Mongo::OperationFailure: Database command 'mapreduce' failed:
    {"assertion"=>"'out' has to be a string or an object",
    "assertionCode"=>13606, "errmsg"=>"db assertion failure", "ok"=>0.0}
    

In the `map_reduce` call `map` and `reduce` are class methods of MySchemalessModelClass.  `map` is called for each matching document in the query and 'emits' a value, `reduce` gathers all of the emitted values and produces a result.  Both `map` and `reduce` are JavaScript strings which mongoDb executes. As Chris Umbel shows,  they can be nicely represented in ruby to look like the functions they are by wrapping them in a class method and a here document...

    :::ruby
    class MySchemalessModelClass
      self.map
        <<-JS
        function(){
          emit(this.mytype, 1);
        }
        JS
      end

      self.reduce
        <<-JS
        function(key, values){
          var count;
          values.forEach(function(value) {
            count += value;
          });
          return count;
        }
        JS
      end


In Chris's example each map-reduce function is encapsulated in its own class, which I agree is nicer (I'm just trying to keep the description simpler by not introducing another class).  `map` and `reduce` must contain an anonymous JavaScript function which calls `emit` with a key and the output for that key.  In our example we are creating a histogram our `mytype` and so `map` passes `emit` `mytype` as the key and a count of 1.  `map_reduce` calls map for each document and builds an array of values ([1,1,1,1]) for each key.  Then for each key `map_reduce` calls `reduce` which should process the array of values and reduce it to a single value.  This means `reduce` can be called arbitrarily any number of times with any number of values. `reduce` delivers its output through its return value where as `map` uses `emit` but the structure of each must be the same.  This makes sense when you consider that the output from `reduce` can be a partial value that is fed back in as part of the array of values at a later date.  Typically this happens with database inserts where the newly added data only needs to be mapped and reduced with the previous result.

The return value of the call to `map_reduce` is either the collection which containes the results or a hash which includes the results themsleves.  If you specify a collection then unless you specify another option when calling `map_reduce` [(see here)](http://www.mongodb.org/display/DOCS/MapReduce#MapReduce-Outputoptions) the contents of the collection will be replaced by each call to `map_reduce` with one entry for each key given to `emit`.

Hope that's enough to get you going.


[hr]: http://www.horizon.ac.uk/Home
[mm]: http://mongomapper.com/documentation/plugins/querying.html

