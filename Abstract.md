# Abstract

Tidalcycles is a popular language for improvising live-coded music. Tidalcycles allows artists to manipulate musical pattern using a Domain Specific Language (DSL) written in the Haskell programming language.
Alex McLean, who is the primary author of Tidalcycles has recently begun several related projects that involve re-writing Tidalcycles from scratch as a form of design inquiry.
In addition to a "clean-room" re-write of Tidalcycles in Haskell, McLean and the larger community have undertaken the project of translating Tidalcycles into other programming languages.
Tidalcycles has so far been translated into Python, Javascript, and Kotlin. These projects, codenamed vortex, strudel, and kidal respectively, have allowed the community to explore the nature of tidal as a pattern language separate from the formal language it is implemented it. They have also broadened the community. Particularly the strudel program has a quickly growing user-base and, as it is browser based, offers unique affordance.

This project aims to continue exploring the design space afforded by the process of translation/re-implementation.
Individually, I hope to learn about the construction of livecoding languages by "hand-building" one - much as an apprentice luthier might build a guitar in order to learn how to build guitars.
Additionally, I hope to begin answering some larger questions about livecoding languages as musical tools. While I don't imagine this project will answer the following questions, I expect it to provide interesting context for the following:
- To what extent can the pattern language of a livecoding language be separated from its formal language?
- What can we learn about the nature of the pattern language by attempting to separate it from its host programming language?
- How to the affordances of a particular formal language affect the implementation and end user experience of a livecoding system?
- What new design possibilities does the process of translation reveal? How will they affect the development of Tidalcycles? How will they affect the development of new livecoding systems?

Lua as a host language for tidal may also offer some unique affordances. Lua is a very efficient interpreted language that is easily embedded within low level c and cpp programs. Because of this it is commonly used as a scripting layer for game engines. Tranquility may end up with interesting applications within the video game design and immersive media design space. Additionally, Lua is the language used by the monome norns device. There is a vibrant community of practice surrounding the norns as an instrument. Tidalcycles would likely be a welcome addition to this community.
