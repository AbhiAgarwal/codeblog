+++
date = "2016-02-07T14:19:00+07:00"
draft = true
title = "Prototyping an iOS app using React Native"

+++

This post is a part of a series I am writing. If you haven't already gone through the [Prototyping using Django](/prototying-django) post then you must! Or at least [download/clone it](https://github.com/AbhiAgarwal/prototyping-django) and be able to run it. This tutorial is going to be relying on the API that we wrote. We're going to be building an iOS app using react-native that displays all the events that are happening. The list of events will be served from the REST API that we built using Django. Clone the git repository, and setup the Django application:

```
cd prototyping-django
pip install -r requirements.txt
cd today
./manage.py migrate
```

If you followed the last guide then you can just run the Django application as such:

```
./manage.py runserver
```

If this is giving you an error or you're not able to do it then I have also put up a demo server to let you interact with the REST API. However, this might not permanently be up and so if you are reading this and it's not up -- my apologies! The URL will be:

```
http://todayapp.abhi.co/
```

Now that your Django application is running! Let us move on to working with React Native.

Anyways! What is React Native? The React Native website describes it as "a framework for building native apps using React". The basic idea is that we're able to write iOS applications using Javascript and the [React framework](https://facebook.github.io/react/) that Facebook has built. You must be thinking - why shouldn't I just learn native iOS development using Swift or Objective-C? My answer to that is: Well! We're just prototyping. Sure you could prototype using Swift or Objective-C, but in my experience it has been harder to learn Xcode and Swift while also prototyping an app and building an API. The fact that I can write Javascript and use NPM packages to build an iOS app is magical! We don't need blazing-speed when we're prototyping - we need to get something out the door and get something to test with! Build an [MVP](https://en.wikipedia.org/wiki/Minimum_viable_product) (minimum viable product).

I got started using React Native when I was prototyping, and I was able to get something out the door in just two days! This was just using the React Native documentation and some sample projects that they had on Github. It is not important if React Native is production ready until you have to worry about being productive ready. Premature optimization halts a lot of development. If you are seriously worried about being slowed down in your development time then you should check out some of the apps that were built using React Native [here](http://www.reactnative.com/built-with-react-native/). The Facebook Groups app was built using it -- and I use it! It works like any other native app does!

Lets get started! Firstly, you must have OS X. This is required for iOS development in general. If you don't - I will release an Android version soon :-). Please follow [this](https://facebook.github.io/react-native/docs/getting-started.html#requirements) link to setup the requirements. You will also require Xcode as mentioned [here](https://facebook.github.io/react-native/docs/getting-started.html#ios-setup). Next you should run this command:

```
npm install -g react-native-cli
react-native init today_app
```

This process takes a couple minutes. It has to install all its packages from NPM, and so if you have a weak Internet connection this might take a while. Once it completes you should get the following response (sub my username (abhiagarwal) for your own!):

```
To run your app on iOS:
   Open /Users/abhiagarwal/Desktop/guides/today_app/ios/today_app.xcodeproj in Xcode
   Hit the Run button
To run your app on Android:
   Have an Android emulator running (quickest way to get started), or a device connected
   cd /Users/abhiagarwal/Desktop/guides/today_app
   react-native run-android
```

Great! So we'll be concentrating on the iOS part of this message. I'll be doing an Android tutorial in the future, but not just yet! So lets first change your directory to the `today_app` one. Open it in a text editor such as Sublime Text. Now! We'll open up Xcode and the iOS simulator. This is the current directory structure we have:

```
.
├── LICENSE
├── README.md
├── android
│   ├── ...
├── index.android.js
├── index.ios.js
├── ios
│   ├── today_app
│   │   ├── ...
│   ├── today_app.xcodeproj
│   │   ├── ...
│   └── today_appTests
│       ├── ...
└── package.json
```

The `...` just represent other files, which aren't important to us yet. You can preview your app, and watch it live reload as you change the code. Run these following commands:

```bash
cd ios
open today_app.xcodeproj
```

Then when Xcode opens up click the play button on the top left. This should open up the iOS "Simulator", and a Terminal window. When the simulator opens up you should see the app say "Welcome to React Native!". It should be like this:

<img src="../welcome_to_react_native.png" alt="">

This is the default screen that comes with the default react-native `index.ios.js` file. Go back a directory by doing `cd ..`, and open up `index.ios.js`. Before editing the main file we need to install some packages:

```bash
npm install redux --save
npm install react-redux --save
npm install react-router --save
npm install redux-simple-router --save
npm install redux-thunk --save
```

Your dependencies in `package.json` should look something like this:

```json
"dependencies": {
  "react-native": "^0.18.1",
  "react-redux": "^4.4.0",
  "react-router": "^2.0.0",
  "redux": "^3.3.1",
  "redux-simple-router": "^2.0.4",
  "redux-thunk": "^1.0.3"
}
```

Now let us setup our directory structure. First make a folder called `app`, and then `cd app`. Here we're going to make 4 folders. Run `mkdir actions components containers reducers`. This will make 4 folders:

- `actions`: "are payloads of information that send data from your application to your store. They are the only source of information for the store" [1].
- `components`: "When designing interfaces, break down the common design elements (buttons, form fields, layout components, etc.) into reusable components with well-defined interfaces. That way, the next time you need to build some UI, you can write much less code. This means faster development time, fewer bugs, and fewer bytes down the wire" [2]. Components allow programmers to reuse our components.
- `containers`: "is route's handler, which also pulls redux's state for that route" [3].
- `reducers`: "actions describe the fact that something happened, but don’t specify how the application’s state changes in response. This is the job of a reducer" [4].

This structure follows the philosophy of Redux. What is Redux you say? The website says: "Redux is a predictable state container for JavaScript apps", and "it helps you write applications that behave consistently, run in different environments (client, server, and native), and are easy to test" [5]. Well... that's great, but why are we using it with React Native? A reason I found online was that "managing state in an application is critical, and is often done haphazardly. Redux provides a state container for JavaScript applications that will help your applications behave consistently" [6]. Hm! That makes much more sense. So we're using Redux because we want to control the state of our Javascript application.

## Actions

We're going to start from building actions first. Switching into actions by `cd actions`, and then `touch actionTypes.js eventActions.js`. In `actionTypes.js` put:

```javascript
export const REFRESH = 'REFRESH';
```

In `eventActions.js` put:

```javascript
import * as types from './actionTypes';

function receiveFeed(feed) {
  return {
    type: types.REFRESH,
    events: feed.events
  }
}

export function getFeed() {
  let contextURL = `http://todayapp.abhi.co/api/events/?format=json`;
  return dispatch => {
    fetch(contextURL, { method: "GET" }).then(function (response) {
      return response.json();
    }).then(function (responseData) {
      if (responseData.results && responseData.results.length > 0){
        dispatch(receiveFeed(responseData.results[0]))
      }
    }).done();
  }
}
```

These two files are what we use to refresh our feed or get our initial feed. Getting the feed is the same as refreshing the feed, right? Since in both actions we are overwriting the previous data with new data.

## Reducers

Reducers can be seen as models for our app. Lets get started. Change directory into reducers, and create two files. `touch event.js index.js`. In `event.js` you should put:

```javascript
import * as types from '../actions/actionTypes';

const initialState = {
  events: [],
  isLoading: true
};

export default function event(state = initialState, action = {}) {
  switch (action.type) {
    case types.REFRESH:
      return {
        ...state,
        isLoading: false,
        events: action.events
      }
    default:
      return state;
  }
}
```

## Containers

Our first container is our home page screen container. First create the `app.js` file.

1. https://rackt.org/redux/docs/basics/Actions.html
2. https://facebook.github.io/react/docs/reusable-components.html
3. https://rackt.org/redux/docs/basics/Reducers.html
4. https://github.com/rackt/redux/issues/756
5. https://www.npmjs.com/package/redux
6. https://egghead.io/series/getting-started-with-redux
