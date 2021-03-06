--- 
title: Making References Work
date: 08/Nov/2011
tags: writing
---

So I have a vision for my blog of using a single writing format to create blog posts and academic papers.  I use [Maruku](http://maruku.rubyforge.org/index.html) in my blog to convert elegantly formatted text files into elegantly formatted HTML files for the web (see [The World's Most Satisfying Blog](/2011/11/satisfying-blog.html).  Pleasantly Maruku supports export to Latex making the possibility of the transition from blog post to academic paper seem plausible.  The single biggest issue to solve is making references elegant.


The ideal
----------

What I would like is to gather references for the books and articles that I read in a simple and accessible system.  Preferably with the absolute minimum of tedious and error prone typing.  When I come to make reference to a source I want to be able to search through my catalog (preferably full text) to find the source that I have in mind and identify it by a simple knowable key - perhaps a composite of first author, year and number (e.g.  `thibodeau201101`  Then to include it in my article I would like to use a simple markup, perhaps like `[]{thibodeau201101}` and have that automatically create a footnote to the citation in the case of formatting to a web page, or a bibliographic entry in the case of formatting a paper.


The state of the art
--------------------

There are a wealth of reference management solutions out there and a comprehensive [comparison of reference management software here](http://en.wikipedia.org/wiki/Comparison_of_reference_management_software).  Frankly I find this kind of feature compasison dificult to navigate, but regardless it is a good list.


Collecting References
---------------------

For academic articles this problem of collecting the reference is nicely solved by [Citeulike](http://www.citeulike.org/) which, with the addition of a tool-bar bookmark can gather the details of academic articles posted on the web (which is most of them).  Ironically it is when you have the full text PDF that using Citeulike seems a struggle.  If often takes quite some time to find a location that references the paper in a way that Citeulike knows how to parse.  To reference a book takes extra steps again:

* Go to [Google Books](http://books.google.com/)
* Search for the book you want to reference.
* At the bottom of the page click the `Export Citation: BiBTeX` button.  Unfortunately Google Books will not just show you the BiBTeX citation which you could paste into Citeulike, but rather downloads a file with the extension `.bibtex`.
* Go to [Citeulike](http://www.citeulike.org/).
* Assuming you are logged in you can choose the `MyCiteULike -> import` option.
* Select the file just downloaded and fill in any tags that you want to use.
* Click `Import BiBTeX File`.

It's a bit fiddly but it works.


Knowing what I've got
---------------------

The next step is finding the reference I want.  Typically this involves searching through the pdfs or web for the relevant and half remebered section.  Of course citeulike does not gather full text pdfs.


Citing
-------

BiBTeX uses a unique key for each entry based on the surname of the first author, the year of publication and the first word of the title.  Since this is quite constructable while typing it is ideal for using as the markup reference.  So in order to have a well formatted citation to "Metaphors we think by" by Paul Thibodeau I just want to include something like `[^thibodeau2011metaphors]()` and have my blog source the citation from citeulike and format it nicely for web or paper.

[^Alechina//:10a]() considers reasoning about coalitions of resource bound agents.

Making it work
--------------

For this I will need to extend markdown to include BiBTeX.

One complicating factor is the number of citation styles that could be supported.  In the first instance I will restrict myself to 

