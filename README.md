# WhereYouAt?

Description:
This app helps people coordinate when trying to meet up for an event. It will allow users to create events and view the location of each person and the time it will take for each of them to reach the event location.

## User Stories

Core:
- [x] Have a profile for each person
- [x] Create an account using Parse
- [x] Search other users and add them as friends
- [x] Global chat
- [x] Have a map showing the destination of the events and how far other members are from the event
- [ ] Notification when getting a message

Optional:
- [ ] Search for nearby events
- [ ] A poll function in chat channel
- [ ] planning schedule
- [ ] Setting / personalized app
- [ ] Notification of invitation to events
Parse Data Tables <br/>
Event<br/>
{<br/>
    "_id": "_id",<br/>
    "_p_author": "_User$_p_author",<br/>
    "location” : “location",<br/>
    "description": "description",<br/>
    "attendees": "attendees",<br/>
    "media": "media",<br/>
    "_created_at": "_created_at",<br/>
    "_updated_at": "_updated_at"<br/>
}<br/>
<br/>
_User<br/>
{<br/>
    "_id": "_id",<br/>
"username": "username",<br/>
“password”: “password”,<br/>
“screen_name”: “screen_name”,<br/>
 “email”: “email”,<br/>
“friends_count”: “friends_count”,<br/>
    "_created_at": "_created_at",<br/>
    "_updated_at": "_updated_at"<br/>
}<br/>
<br/>
ChatMessage<br/>
{<br/>
    "_id": "_id",<br/>
    "text": "text",<br/>
    "_p_User": "_User$_p_author",<br/>
    "_created_at": "_created_at",<br/>
    "_updated_at": “_updated_at”<br/>
}<br/>




What is your product pitch?<br/>
Start with a problem statement and follow up with a solution.<br/>
Focus on engaging your audience with a relatable need.<br/>
The biggest struggles when meeting up with friends is finding our friends. It is not always easy to find your friends and we always end up losing precious hang out time. <br/>
When using WhereUAt, you and your friends' location will be showed and shared on the app so that it will save a lot of time by avoiding spending time on finding your friends.<br/>

Who are the key stakeholders for this app?<br/>
Who will be using this?<br/>
What will they be using this for?<br/>
Everybody can use our app, but the app works especially for people who always go out with their friends. People will use the app when they are meeting up their friends but have a hard time finding thier friends.<br/>

What are the core flows?<br/>
What are the key functions?<br/>
What screens will each user see?<br/>
The core function is to help people to see the location of their firends who are going to the same event with them. They will see a map screen to see the locations of their friends (as pins), a profile screen, a searching sreen to add friends, an event screen and a chatting screen, a home screen.<br/>

What will your final demo look like?<br/>
Describe the flow of your final demo<br/>
After logging into the app, the user goes to the home screen that shows the upcoming events. The user can click the events and check the profile of the events. Then the user finds he has a event coming up in 30 mins with his friends at Westfield UTC, so he decides to go now. When he drives to UTC, he opens the map screen and sees one of the friends is at the parking strcuture too, so he finds his friends easily. Also, they see many of their friends are at Starbusks so they decide to meet them all at Starbucks. Then the user recieves a message from his friend saying that she will be late. When they come to the event, they find many new people so they search them on the searching screen and see their profiles and add some new friends.<br/>

What mobile features do you leverage?<br/>
Leverage at least two mobile-oriented features (i.e. maps and camera)<br/>
Our app depends on the map function.<br/>
Our app can also call users' friends.<br/>

What are your technical concerns?<br/>
What technical features do you need help or resources for?<br/>
Location tracking.<br/>
