# Message In A Bottle

## Inspiration
We were inspired by the concepts of messages in a bottle being washed on on shore and found by random strangers. This concept led us to design the idea of a user collecting random messages while walking, and being able to create their own messages to send out.
## What it does
While the user is walking, they can click on any bottle within range (indicated by the blue circle on the map) to open it and read it. This encourages the user to go on a journey and collect as many messages as possible. When the user is done reading a message, they can choose to create their own message to send out. Once the new message is created, the app waits for a random amount of time, then drops the bottle at the user's current location, ensuring that someone new will read the message and continue the journey.
## How we built it
We used Flutter to create the app itself and design the UI/UX. We used Firebase to handle authenticating users and storing data about the bottles. We used Android Studio to emulate an Android phone for testing the app.
## Challenges we ran into
One primary challenge was learning Flutter, since most of us did not have any experience with it. We were able to use the documentation in order to implement functions such as separate log-in and map pages, embedding an interactive map, and adding bottles that opened when tapped. Another challenge was using Firebase, since we also did not have much experience working with it. By reading the documentation for Firebase and Flutterfire (combines Flutter and Firebase), we created a secure authentication system and were able to efficiently store bottles in the cloud.
## Accomplishments that we're proud of
We are proud of learning Flutter in a limited amount of time and developing an app with embedded mapping and authentication capabilities. We are also proud of learning Firebase in order to implement secure databases and datastores. We are also proud of our UI/UX design, which is aesthetically pleasing and makes it simple for users to operate the app.
## What we learned
We learned about Flutter, Firebase, UI/UX design, and version control.
## What's next for Message in a Bottle
In the future, we plan to send push notifications when a user is close to a bottle, so that they can leave the app running in the background.