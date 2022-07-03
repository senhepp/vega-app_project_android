## Purpose of the work

The basic department maintains a large collection of information resources,
primarily scientific books and articles related to the interests of employees and students.
There was a need to organize and access these resources in a more user-friendly way.
As part of the research work, the task was set to create a cross-platform mobile application
to display a list of documents from the Vega's collection of information resources
and filter them by keyword if there is a sample of such an application on iOS
to expand the audience of department resources users.

## To-do

The task was to develop a cross-platform application based on the Flutter framework,
displaying and filtering a list of documents, which sends a request to the presented API,
receives information about stored documents as a response and displays a list of them on the application screen.

- link to department's API is [here](vega.fcyb.mirea.ru/intellectphp/)

## Development tools used

Android Studio BumbleBee 2021.1.1, Flutter 3.0 tools and Dart 2.17.0 language capabilities.

## Content and result of the work performed

In accordance with the calendar-thematic plan of practice, the following were studied:
- technologies for writing a mobile application;
- Working with the Flutter framework: how to work with the network, how to send network requests and receive data on them;
- Dart language: syntax, capabilities for writing applications, compatibility with Flutter;

By studying the tools described earlier, the following were implemented:
1. methods of working with the network, in particular, the Session class is implemented,
which is responsible for authorization, cookie management and sending requests to the server for further work with the received documents.
 
2.	графическая часть приложения, состоящая из трех основных частей:

![graphic interface](https://drive.google.com/file/d/1iXG6Kyf5JyteAu378xcHH6FlAvRiKOwz/view?usp=sharing "graphic interface")

- header part;
- search bar;
- summary table from the main information on documents, divided into separate cells;

3.	Methods of filtering documents by keywords. Entering the capability of user interaction with the search bar.
![User interaction with search bar](https://drive.google.com/file/d/1fo2h4s0B0_AvY8biOm610c-ea9Wy_Sfw/view?usp=sharing "User interaction with search bar")

4.	Graphical representation of the animation during the search
and further updating the display of the list of documents that meets the user's request.
![Graphical representation](https://drive.google.com/file/d/1OYCZVqdrTdE_mv_AgQ6lR-_kN8B-vnOi/view?usp=sharing "Graphical representation")
![updating the display](https://drive.google.com/file/d/1fo2h4s0B0_AvY8biOm610c-ea9Wy_Sfw/view?usp=sharing "updating the display")
