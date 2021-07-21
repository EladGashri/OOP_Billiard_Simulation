A Billiard Simulation written in Smalltalk, a pure object-oriented programming language.

The ball objects interact with each other and with objects from other classes by sending messages. methods in response to the messages calculate the balls movement in respond to the player interaction and physical collision between objects.

Each game component is represented by a different class, implementing the abstraction principle. Each one of those classes is a subclass of the Morph class, which represents a graphic object. Different classes respond differently to the same messages for game events, according to the game component every class represents, implementing the polymorphism principle.
