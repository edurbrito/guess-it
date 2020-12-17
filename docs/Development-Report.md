# openCX-esofagos Development Report

Welcome to the documentation pages of the GuessIt of **openCX**!

![](images/logo.svg)

You can find here detailed about the (sub)product, hereby mentioned as module, from a high-level vision to low-level implementation decisions, a kind of Software Development Report (see [template](https://github.com/softeng-feup/open-cx/blob/master/docs/templates/Development-Report.md)), organized by discipline (as of RUP): 

* Business modeling 
  * [Product Vision](#Product-Vision)
  * [Elevator Pitch](#Elevator-Pitch)
* Requirements
  * [Use Case Diagram](#Use-cases-diagram)
  * [User stories](#User-stories)
  * [Domain model](#Domain-model)
* Architecture and Design
  * [Logical architecture](#Logical-architecture)
  * [Physical architecture](#Physical-architecture)
  * [Prototype](#Prototype)
* [Implementation](#Implementation)
* [Test](#Test)
* [Configuration and change management](#Configuration-and-change-management)
* [Project management](#Project-management)

So far, contributions are exclusively made by the initial team, but we hope to open them to the community, in all areas and topics: requirements, technologies, development, experimentation, testing, etc.

Please contact us! 

Thank you!

* [Daniel Gonçalves](https://github.com/Esdeath-GK)

* [Eduardo Brito](https://github.com/edurbrito)

* [Paulo Ribeiro](https://github.com/PJscp16)
  
* [Pedro Ferreira](https://github.com/pdff2000)

* [Pedro Ponte](https://github.com/pedrovponte)


---

## Product Vision

A game that aims to empower conferences with interactive learning, so that people, at a given session, can play with each other, have fun and put their knowledge about the subjects to the test.

---
## Elevator Pitch

**GuessIt** is a brand new game designed for the audience of a given conference. It allows the speaker to test the public knowledge about the learned concepts, challenging everybody in the room.
In this interactive game, there are two types of players:

* **The “Leaders”**, who have to describe the concept they were given the best they know, within the given time, by giving definitions of what they were assigned to explain.
* **The “Guessers”**, who have to guess the right word within the given time, and try to be the fastest ones. They write their guesses to a live chat, where they can see others’ failed answers.
Therefore, the participants get to play and learn with each other, while having a lot of fun!

---
## Requirements

### Use cases diagram

![Use Cases Diagram](images/UseCasesDiagram.png)

#### **Create game:**
* **Actor:**
Conference Speaker
* **Description:**
This use case exists so that the speaker can define the game schedule (duration and starting time) and the list of words related to the session to be used in it.
* **Preconditions and Postconditions:** 
In order to set the game definitions, the conference speaker must first login into the application. After this use case, a game session will be created, and any conference participant may join.
* **Normal Flow:**
1. The conference speaker presses the Login button, to get admin access to the application.
2. The conference speaker inserts the admin code.
3. If the code is accepted, admin access to the application is granted to the speaker.
4. After this, the speaker chooses the starting time and duration of the game, as well as the list of words.
 
* **Alternative Flows and Exceptions:**
1. The conference speaker presses the Login button, to get admin access to the application.
2. The conference speaker inserts the admin code.
3. If the code is rejected, admin access to the application is denied to the speaker.
4. The speaker can then retype the code, and proceed as normal.
 
 
#### **Post definitions:**
* **Actor:**
Leader (extends Player)
* **Description:**
This use case exists so that the current game leader can write its definitions of the current word and show them to the guessers.
* **Preconditions and Postconditions:**
In order to post a definition, the player must first join the game session. In the end, the player’s definitions will be shown to all the other players in the live chat.
* **Normal Flow:**
1. While playing, the player may get the Leader role - he must then write some definitions and send them to the chat.
2. If the definition is allowed and checked by the system, it will be shown to all the guessers.
* **Alternative Flows and Exceptions:**
1. While playing, the player may get the Leader role - he must then write some definitions and send them to the chat.
2. If the definition is not allowed by the system, it will be hidden and the leader gets a warning.
3. The leader can then retype his sentence, and proceed as normal.


#### **Post guesses:**
* **Actor:** 
Guesser (extends Player)
* **Description:**
This use case exists so that a Guesser can write its guesses of the right word and send them to the live chat.
* **Preconditions and Postconditions:**
In order to write its guesses, the player must first join the game session. In the end, the player’s guesses will be shown to all the other players in the live chat, unless its guess is right or close to the right answer.
* **Normal Flow:**
1. The Guesser writes its guess.
2. If the guess is right, it isn’t shown in the chat, and a message is displayed telling the Guesser that it was correct.
* **Alternative Flows and Exceptions:**
1. The Guesser writes its guess.
2. If the guess is close to the right answer, it isn’t shown in the chat, and a warning is displayed telling the Guesser that it’s not far from being correct.

* **Or:**
1. The Guesser writes its guess.
2. If the guess is wrong, it will be shown to all the guessers.


### User stories

> Actors: Guesser or Leader; Speaker

#### **User Story 1:**
As the conference speaker, I would like to have an admin panel in order to create the next game session.

| ![](images/UserStories/panel1.png) | ![](images/UserStories/panel3.png) | ![](images/UserStories/panel4.png) |
| --- | --- | --- |

**Acceptance Tests:**
```gherkin

  Scenario: Entering as an admin
    Given I am in the Landing page
    When I tap the “Enter as Admin” button
    Then I am in the Admin Code page

  Scenario: Inserting the admin code
    Given I am in the Admin Code page
    And I insert the correct admin code
    When I tap the “Log In” button
    Then I am in the Admin Panel page

```

**Value:** Must have

**Effort:** L

-----

#### **User Story 2:**
As the conference speaker, I would like to define the starting time and the duration of the game, so that I don’t have to worry about unforeseen delays.

![](images/UserStories/panel4.png)

**Acceptance Tests:**
```gherkin

  Background:
    Given A Speaker S
    And S is in the Admin Panel Page
    
  Scenario: Choosing the date for the session
    Given I logged in as Speaker S
    When I tap the “Date dropdown”
    And I choose a Date X for the game session
    And I tap the “Ok” button
    Then A new Date X is assigned to the game session

  Scenario: Choosing the time for the session
    Given I logged in as Speaker S
    When I tap the “Time dropdown” button
    And I choose a Time Y for the game session
    Then A new Time Y is assigned to the game session

  Scenario: Choosing the duration for the session
    Given I logged in as Speaker S	
    When I tap the “Duration” textbox
    And I insert a Duration Z for the game session
    Then A new Duration Z is assigned to the game session

```

**Value:** Must Have

**Effort:** M

-----

#### **User Story 3:**
As the conference speaker, I would like to suggest a list of concepts related to my session, so that it can be used by the app to include them in the game.

![](images/UserStories/panel4.png)

**Acceptance Tests:**
```gherkin

  Background:
    Given A Speaker S
    And S is in the Admin Panel Page

  Scenario: Choosing the list of concepts for the session
    Given I logged in as Speaker S
    When I tap the “Add a word” button
    And I write a word W
    And I press “Enter”
    Then A new Word W is added to the list of words

```

**Value:** Must Have

**Effort:** M

-----

#### **User Story 4:**
As a player, I would like to participate in the game anonymously, so I can feel more at ease and freely write my guesses without the fear of failing.

![](images/UserStories/panel2.png)

**Value:** Must Have

**Effort:** S

-----

#### **User Story 5:**
As a player, I would like to see all the other players’ missed answers in a live chat, so that I can get some insights about my potential guesses.

![](images/UserStories/panel5.png)

**Value:** Must Have

**Effort:** XL

-----

#### **User Story 6:**
As a guesser, I would like to know if I'm close to the answer, by miswriting it or swapping some letters.

![](images/UserStories/panel5.png)

**Value:** Could Have

**Effort:** M

-----

#### **User Story 7:**
As a leader, I would like the game to give some clues about the word if the players are taking too long to guess it, like writing my definitions of it or saying how many letters it has, for example.

![](images/UserStories/panel6.png)

**Value:** Must Have

**Effort:** M

-----

#### **User Story 8:**
As a player, I would like to see a ranking of all the players, based on the points they made.

**Value:** Could Have

**Effort:** M

-----

#### **User Story 9:**
As the conference speaker, I would like to see the statistics of the game, so I can know which words were the most difficult to guess, in order to better explain those topics to the audience.

**Value:** Could Have

**Effort:** M

-----

#### **User Story 10:**
As the conference speaker, I would like to generate a final report with the word definitions given by the players, so that I can discuss them with the audience.

**Value:** Could Have

**Effort:** M

-----

### Domain model

![Domain Model Diagram](images/DomainModelDiagram.png)

The project is constructed on top of a very simple structure and concept. There is a scheduled session, with its own game, where the players need to guess the word described by the **Leader**.

To conceive this idea, three main classes were created. The **GuessItSession** class is the one in charge of the words that can be used in the game. It represents the session itself and makes the connection between the **Speaker** class (the orator) and the **Schedule** class (the Time and Duration of the session).

For the player structure, we created an abstract class that can be instantiated either by a **Guesser** or a **Leader** class. In each game, the **Leader** can only be one player, whereas the other participants shall be all guessers. To represent the guesser answer we opted for the inclusion of the design pattern *State*. This state can either be **CorrectAnswer** (where the word guessed is the correct one), **CloseAnswer** (meaning the answer is partially right. For example, let's suppose the guesser wrote "guesit" instead of "guessit". The player would likely assume its word was wrong, when in fact is just misspelt. With this state, instead of the word being written to the chat, the player will be informed its word is almost correct) and at last the **IncorrectAnswer** (showing the guessed word is totally incorrect).

However, the central class of the project is the **GameRound** class. This class makes the connection between the **Session** itself and all the players/participants present at the conference. It is responsible for the game features, such as the **Leader** word, the time remaining, the points to be given and the definitions chosen by the **Leader**.

----

## Architecture and Design

The architecture of a software system encompasses the set of key decisions about its overall organization.

### Logical architecture

![Our Logical Architecture](images/logical.png)

Our high-level structure will follow the MVC Architectural Pattern, as it is a good standard for this type of project.

Firstly comes the Model, that contains all the application data, including the game session settings, the players' info, and all the chat related data. 

Next, it's the View, representing the concrete display of the app state and data for its users. 

Finally, the Controller, the one connecting the other parts, which consists of interfaces that aggregate all the work and, through the users' course of actions, generate or trigger the corresponding functionalities.

### Physical architecture

![Our Physical Architecture](images/physical.png)
The physical architecture of our project relies on two distinct blocks. 

* The Client Side that represents the GuessIt Flutter App, installed on the user's smartphone. 
  
* The Server Side, where the controller will live, containing a Flask API, as a SocketIO implementation, and a connected SQL database to store and persist the needed data. 

Both sides communicate over HTTPS with some required and provided interfaces to simplify all the process. As mentioned, the technologies considered were Flutter, for the mobile UI, as it was globally accepted by all the class, and Flask + SQL, for the server, as a very lightweight and simple combination, that suits perfectly our project needs.

### Prototype

For the application prototype, we aggregated the most relevant User Stories and created a vertical visual prototype. Clicking the buttons triggers the expected flow that the future app will have, navigating through the different screens and states of the application.

The general user interface structure is set and the work on the backend service provider has also begun. The app, as testified, will have a first screen with two possible ways of entering: 
* The *Play* button for Players to choose the nickname and join the game;
* The *Enter As Admin* button that leads the user to the admin panel, if he knows the admin code.

The Admin creates the game, filling the forms and setting the options, and the Players then join it, within a screen that contains a live chat and the other necessary components.

[Our Vertical Prototype with Figma](https://www.figma.com/proto/WvP0fsV2j0afVBldhMCfyF/Story-1?node-id=1%3A3&scaling=scale-down)

![](images/prototype.gif)

---

## Implementation

Changelogs for the different releases of our project can be found [here](https://github.com/FEUP-ESOF-2020-21/open-cx-t4g3-esofagos/releases).

---

## Demo

A presentation-ready *demo* can be watched in the following animated gif, where an environment with multiple players interacting and playing against each other is shown. All the enumerated functionalities and user stories are visibly implemented and well integrated.

![Demo Presentation](images/esof-presentation.gif)

---
## Test

To make sure the app works properly, we've developed some tests in order to see if the implementation of any feature hasn't affected others. For this purpose, we wrote three types of tests:

* [Acceptance Tests with Gherkin](../guess-it/guess_it_app/test_driver)

We wrote 4 of these tests, which allowed us to test the most important features of the flutter app, such as entering as an admin, seeing the Leaderboard Page, and actually joining a game session.

* [Unit Tests - Flutter](../guess-it/guess_it_app/test)

These tests allowed us to test some features similar to those mentioned above, but with a different approach - using unit tests.

* [Unit Tests - Server](../guess-it/guess_it_server/test_app.py)

We've also developed some Python unit tests, to make sure that our local server works properly. This way, we could test if the server connection was successfully established, and if some of its features were running correctly, such as checking the admin code or receiving a new message.

---
## Configuration and change management

Configuration and change management are key activities to control change to, and maintain the integrity of, a project’s artifacts (code, models, documents).

For the purpose of ESOF, we will use a very simple approach, just to manage feature requests, bug fixes, and improvements, using GitHub issues and following the [GitHub flow](https://guides.github.com/introduction/flow/).


---

## Project management

In order to organize our project, we used the project management tool [Github Projects](https://github.com/FEUP-ESOF-2020-21/open-cx-t4g3-esofagos/projects/2).