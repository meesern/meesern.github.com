--- 
title: Psychophenomenology Through Symbolic Modelling
date: 18/Nov/2011
tags: Phenomenology, SymMod
---

A conjecture
=============

That there exists a mechanism through which personal and subjective experience can 


Metaphor
--------

What I would like is to gather references for the books and articles that I read in a simple and accessible system.  Preferably with the absolute minimum of tedious and error prone typing.  When I come to reference a source I would like to be able to search through my catalog (preferably full text) to find the source that I have in mind and identify it by a simple knowable key - perhaps a composite of first author, year and number (e.g.  `thibodeau201101`  Then to include it in my article I would like to use a simple markup, perhaps like `[1]{thibodeau201101}` and have that automatically create a footnote to the citation in the case of formatting to a web page, or a bibliographic entry in the case of formatting a paper.


Collecting References
---------------------

For academic articles this problem of collecting the reference is nicely solved by [Citeulike](http://www.citeulike.org/) which, with the addition of a tool-bar bookmark can gather the details of any academic article posted on the web (which is most of them).  To reference a book takes a couple of extra steps:

* Go to [Google Books](http://books.google.com/)
* Search for the book you want to reference.
* At the bottom of the page click the `Export Citation: BiBTeX` button.  Unfortunately it will not just show you the BiBTeX citation which you could paste into Citeulike, but rather downloads a file with the extension `.bibtex`.
* Go to [Citeulike](http://www.citeulike.org/).
* Assuming you are logged in you can choose the `MyCiteULike -> import` option.
* Select the file just downloaded and fill in any tags that you want to use.
* Click `Import BiBTeX File`.

Citing
-------

BiBTeX uses a unique key for each entry based on the surname of the first author, the year of publication and the first word of the title.  Since this is quite constructable while typing it is ideal for using as the markup reference.  So in order to have a well formatted citation to "Metaphors we think by" by Paul Thibodeau I just want to include something like `[^{thibodeau2011metaphors}]` and have my blog source the citation from citeulike and format it nicely for web or paper.

