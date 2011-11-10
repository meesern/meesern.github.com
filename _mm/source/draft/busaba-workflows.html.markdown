--- 
title:  Busaba Trackable Tableware Demo Workflow Discussion Document
date:   08/11/2011
tags:   Software, Trackable Tableware, Object Container
maths:  true
---

Busaba Trackable Tableware Demo Workflow Discussion Document
============================================================

Overview
--------

This document aims to explore the issues involved in creating the demonstration at Busaba Eathai of a dining experience in which the connection between diner and restaurant is enhanced by a system of visual tracking of crockery.  This document explores the requirements for mapping entities and workflows in order to create an robust set of interactions.


Entities
---------

This section lays out a language for the discussion.

The entities at play in this demonstration are:

Entities       |  Meaning                 | Comment
--------       |  -------                 | -------
The Restaurant | Physical location and    | A single location.
               | organisation.            |
The System     | The computer system used |
               | to provide the customer  |
               | demonstation interaction.|
Kitchen        | The non-public area where|
               | food is prepared.        |
Waiter         | One of front of house    |
               | staff.                   |
Chief          | One of kitchen staff.    |
The Service    | The area where prepared  |
               | food is taken front of   |
               | house.                   |
The Customers  | The set of people who    | 
               | eat at the restaurant.   | 
A Customer     | An individual person.    | 
A Party        | A group of Customers     |
               | seated together and      |
               | eating together.         |
A Bill         | A payment for a specific |
               | party.                   | Not unique to table.
The Tables     | The set of tables        |
               | within the restaurant.   |
A Table        | A physical table.        |
The Dishes     | The set of crockery      |
               | Owned by the retaurant.  |
Dish Type      | The class of dish        | E.g: Side plate, Square serving 
               | identified by size and   | plate.
               | shape.                   |
A Dish         | Any single physical      | Dish has some ambiguity with 
               | peice of tableware.      | Recipie.  Avoid this use.
A Plate        | none                     | Used within Busaba as a metonymy 
               |                          | for food type.  Best to avoid this 
               |                          | term because of ambiguity between 
               |                          | dish and food.
A Food         | Food cooked to a         |
               | particular recipe.       |
Recipe         | A Food _or_ the directions|
               | for preparing a food.    | The two uses of this term can be 
               |                          | ambiguous but probably with little 
               |                          | risk of confusion.
A camera       | The input to the vision  | Cameras are in fixed locations
               | recognition system.      | 
Number String  | The Dtouch output. e.g.  |
               | "1:4:3:2"                |
Dtouch code    | As a number string.      |
Glyph          | A single dtouch fiducial | Differently shaped glyphs which
               | encoding a specific      | encode to the same number string
               | number string.           | are considered to be the same glyph.
Marker         | As a glyph.              | Importantly a marker may *not* be a
               |                          | unique identifier.
Region         | A white space within a   | The number of regions is the number 
               | glyph.                   | of parts of a number string. e.g.
               |                          | "1:2:4" is the number string from a
               |                          | glyph with three regions.
Blob           | A countable point in a   | The number of blobs is counted to 
               | glyph region.            | produce the number in each number 
               |                          | string. "1:2:4" has at most 4 blobs
               |                          | in a region.


Proposed Customer Experience
----------------------------

1) Customer at Table
....................

Customer enters restaurant.  Waiter shows customer's party to a table.  Multiple parties may occupy a table.  Customer takes some action to identify himself to the restaurant.  Customer selects food from menu.  Party orders food from waiter.  Waiter brings food.  Customer presents food to system (in a specific manner).  System delivers recipe information to Customer's mobile phone.


2) Customer at Home
...................

Customer logs in to restaurant website (identifying himself).  Website lists recent visits and the foods delivered to the customer's table for a period following the time of identification at the restaurant. 


Mappings
--------

In order to achieve the simple scenarios described above there are a number of mappings of identity to be created, managed and removed.

These required mappings are: 

* Customer to table
* Food to Marker
* Marker to Table

There exists a range of relevant secondary mappings which may be more or less complex depending upon design decisions.  These are:
* Camera to Table
* Marker to Dish
* Marker/Table pair to Food


Basic Assumptions
.................

A camera is fixed at a table and so identifies the table: 
* Camera identity maps trivially to Table identity.  

An android camera is used by a customer and so identifies the customer:
* Android camera maps trivially to Customer identity.


Customer to table
-----------------

Customer identity
.................

Each customer engaging in the service must be uniquely identified.  This can be achieved by a number of mechanisms depending for a large part on the size of the potential pool of customers to be mapped.

* Dtouch code-space is suitable for identifying from a pool of no more than one or two hundred customers and possibly very much less.  See below for discussion.
* QR is capable of being processed visually. The code-space can comfortably encode from a pool of many billions.
* Other no visual assignments of identity such as user-id would be possible and support an unrestricted pool of customers.

The choice here has implications for the mapping of customer to table.


Table identity
..............

A table can be identified from a pool of around 20.  Typically the restaurant staff know each table by number with the number changing infrequently.

Importantly the identity of a table is not typically known to a customer.



Customer to Table Mapping
.........................

A customer may identify themselves to the system in a number of ways.

1. By registering at a website for a dtouch glyph which uniquely identifies the customer. 
   The Glyph can be presented to the table's camera when seated to create a customer to table mapping.
2. By registering at a website for a QR code which uniquely identifies the customer.
   The QR Code can be presented to the table's camera when seated to create a customer to table mapping.
3. By registering at a website for an identity number on a card which is processed by a waiter.  Waiter enters the customer number and table number into the system via a console.


issues
......

1. -: The usable code space of dtouch is too small for anything but a demo.  +: Using dtouch gives the system an internal consistency.  +: Lowers the burden on the waiter and maximises customer choice in involvement.

2. -: Using QR codes undermines the aesthetic marker ethos. +: Maintains an interaction through vision paradigm.

3. -: Undermines the interaction through vision paradigm, all interaction could be triggered via waters and actioned through the system console. +: Is discrete and unobtrusive.

4. Other options?


Food to Marker
--------------

For a food to be identified by the system the marker on the dish on which the food is served must be mapped to the food over the time at which the marker is identified.

Marker to dish
..............

1. Each dish has a unique marker.  
2. Each dish type has a unique marker.
3. Each dish has one of a limited range of markers.

issues
......

1. +: The ideal case for a system perspective. +: Reduces complexity in mappings.
   +: Reduces complexity in workflows.  -: Requires as many designs as restaurant 
   has dishes.  -: Each broken plate would need to be replaced with the same or 
   new unique design.  +/-: Designers need to produce high number of unique designs.
   Estimate at greater than 400 dishes.
2. Workable only if each food is only served on one dish type.  +: Reduced complexity
   in mappings.  +: Mappings easily understood.  +: Designs limited to number of foods
   (< 50).  
3. +: Simple mapping if each food is only served on a dish with a particular marker.
   -: Requires managing stocks of dishes per food.  -: Dynamic mapping of food to
   marker/table pair over time is possible but complex.  Discussed below.


Dynamic Mapping of Food to Marker
.................................

If case 1 (unique markers per dish) is rejected as impracticable and case 2 (unique markers per dish type and fixed food per dish type) is rejected as undesirable then a marker can only have 'meaning' within a context that includes time, food, table and marker and only then if care is taken to ensure that the tuple of [table, food, marker] is unique at the point that identification is requested.  In other words a marker can only mean a food when presented at a particular table over a particular time and the system has ensured that no other identical marker with a different food has been served to that table in the 'recent past'.


Marker to table
...............
To ensure that a marker is unique on a table in a time period a clean dish can be selected in the kitchen and checked against the required table.  When a dish marker that is unique to the table in recent past has been found the system needs to be informed of the mapping of dish marker to table.  One possibility for this is to use a camera at the service area and present a proposed plate at the same time as a dtouch 'tag' identifying the required table.  The system can report a non-unique dish/table pair prompting the waiter to retry with a different dish.


Marker to table time period
...........................

The uniqueness of the [marker,table] tuple must only be maintained over sufficient time as to avoid ambiguity.  For each party the time of interest is from arrival to departure, for the system however this is confounded by the property that multiple parties share a table.  Because the times of relevance for parties overlap, a proposed approach is to ensure that the time period before which a marker can be reused on a table is longer than the longest expected stay of a party.  We expect this to be two hours.



Mapping food to dish
.....................

In the case of non-unique mappings of dish marker to food the mapping must be created dynamically.  That is the system must be told which food is on the dish at any one time.  One way to do this would be with a mechanism similar to that proposed to map plate to table.  Using the service area camera a validated dish prepared with food can be presented to the vision system along side a dtouch tag identifying the food and a dtouch tag reasserting the table.  

Clearing down
.............

Once the mapping of food to marker is established it must be maintained for an appropriate time at least until the customer's last opportunity to interrogate the dish.  Several options exist for clearing down the mapping.

1. Timeout
2. Cleared down by Waiter presenting empty plate and a 'cleardown' tag to the service area vision system.
3. Other?

issues
......

1. +: Needs to be in place regardless of any other mechanism.  +: It  may be sufficient to maintain the mapping until the dish marker is permitted to be reused at the table.
2. +: Provides positive end to mapping that is closer to facts.  -: Presenting a used dish adds a burden to the staff.  -: Presenting a used dish may add difficulties to the vision system through contamination of the markers.


Hybrid Solution
...............

One hybrid solution could be to fully constrain marker to dish type and partially constrain food to dish type such that each dish type can be used for a small number of foods.  Here food defines dish type but dish type does not define food.  This has the advantage of fitting with Busaba existing practice.  The problem remains unsolved of manging the restricted mapping of food to marker.



Marker to Table
---------------

In the case of the fixed cameras the problem of identifying the marker at a table is a trivial one as the camera the recognises the marker maps to the table at which the dish carrying that marker is present.

In the case of a mobile phone (android) app. the mapping is less clear.

Options
.......

1. Mapping via customer and customer's mapping to table.
2. Customer enters table number at point of identifying food.
3. Other?


Issues
......

1. +: Simple and automatic.
   -: Customer may choose to identify a dish at another table (if a large party is split across tables for example). 
2. +: Can work across tables. -: Insecure (can reveal information about other tables).



Vision System Issues
---------------------

Dtouch Codespace
................

The number of codes that can be represented by dtouch may be quite limitied.  The problem can be represented as a multiset with cardinality k taken from a set of size n where k is the number of dtouch regions and (n-1) is the maximum number of blobs in each region.

The code space is represented by:

$n^k ̅ /k!=  (n(n+1)…(n+k-1))/k!$

For small numbers it looks like this...
![dtouch-codespace](/img/dtouch-codespace-shape.gif)

In other words the number of number strings that can be expressed is small for our purposes unless the number of regions is above four and the maximum number of blobs in each region is above twelve.

This table shows the number of codes that can be generated for various numbers of regions and blobs.  Regions are in rows and blobs in columns.

| R/B | *4* | *5* | *6* | *7* | *8* | *9* |  *10* |
| *3* | 10  | 15  | 21  | 28  | 36  | 45  | 55    |
| *4* | 35  | 70  | 216 | 210 | 330 | 495 | 715   |
| *5* | 56  | 126 | 256 | 462 | 792 | 1287| 2002  |
| *6* | 84  | 210 | 462 | 924 | 1716| 3003| 5005  |
| *7* | 120 | 330 | 792 | 1716| 3432| 6435| 11440 |
| *8* | 165 | 495 | 1287| 3003| 6435|12870| 24310 |
 


Dtouch Recognition Stability
.............................

Overview
........

Existing implementations of dtouch process video on a frame by frame basis.  Each video frame being treated as a still image.  The vision system converts the image to grayscale and then applies a threshold such that each pixel takes on one of two values - black or white.  The code then scans the image to discover the map of connected regions (blocks of continuous black or white).  This map or tree of connected regions is scanned for relations that conform to the rules for a dtouch marker (identify a root with at least three regions where no more than two are empty and each region contains only leaf regions). These rules create the following constraints on markers.

1. It is not a glyph if there are two or fewer regions.
2. It is not a glyph if there are more than two empty regions.
3. It is not a glyph if region contains a blob that contains another region.


There are a number of problems in using dtouch as the visual recognition system.

Movement
........
The existing dtouch implementations are poor at tracking movement as motion blur prevents detection and may produce spurious marker detection.


Specular Reflection
...................

To the image processing specular reflection is indistinguishable from the design of the glyph.  Its effects are typically to break a line or obscure a mark.  While this often invalidates the recognition by breaking rules 1 above, it will frequently distort the recognition by merging regions or obscuring only some blobs.


Code Resilience
................

One of the most significant operational problems with using dtouch to determine identity is likely to be mis-recognition.  Perturbations of the input frequently cause more or less stable recognition of the wrong value.  This can be mitigated against by constraining the system to recognise only those codes that are expected but this solution is only of value when the number of codes in use is small compared to the number of possible codes.

To prevent the vision system mis-reporting codes capacity to distinguish valid to artificial codes should be designed on top of dtouch.  Options include

1. Constrain numbers of blobs to be divisible by some small number (3)
2. Constrain numbers of blobs to be identical in two regions
3. Use one region as a checksum of the others - this may be functionally identical to 1.
4. Build additional constraints into valid code design beyond those in dtouch 

In general the stronger the resilience of the coding system the greater the required codespace.  Larger codespace constrains the designers more than smaller codespaces.


Codespace size
..............

The size of the required dtouch codespace will be dependent upon decisions made relating to options in other parts of this document.  However, if the system is to operate beyond a demonstration context then dishes should be designed with sufficient codes to encode all menu items (50) and to allow a low probability of selecting a repeated code for a table within the requisite mapping time (80).

Independent dtouch codes may also be required for tags to encode table and food (20+50) giving a codespace requirement of at least 150 and possibly significantly higher.

With a checksum for resilience this can be achieved by designing codes with four regions each of which can hold up to sixteen blobs or five each of which can hold up to six blobs.

    4x16
    5x6


Resolution
..........

The fixed high definition camera can resolve 1280 x 740 pixels.  We estimate that for the initial demonstration the camera will be mounted in the lampshade above the table at a hight of one meter.  

The camera view area is described by a rectangular pyramid with proportions hight:1, width 0.8 and depth 0.46 (with HD aspect ratio).


* At 1 meter mounting camera coverage is *80cm x 46cm*
* At 1280x740 acuity is *1280/800 pixels/mm* 1.6 pixels/mm
* At 640x480 acuity is *800/480 mm/pixel* or 1.6 mm/pixel

While high resolution allows detection of fine lines it also allows small discrepancies to be detected as nested regions which invalidate the codes.  Because of this it is unlikely that we can work with an acuity finer than 1.6mm/pixel.

This creates a lower limit on the thickness and separation of each line that comprises the glyph and can give us a set of constraints on the designs as follows.

1. Each marker has five regions.
2. Each region must encode up to six blobs.
3. Each line must be at least 1.6mm thick.
4. Each line must be separated from every other by at least 1.6mm.



Proposed Workflow
==================




