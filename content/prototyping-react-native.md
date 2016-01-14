+++
date = "2016-02-07T14:19:00+07:00"
draft = true
title = "Prototyping an iOS app using React Native"

+++

This post is a part of a series I am writing. If you haven't already gone through the [Prototyping using Django](/prototying-django) post then you must! Or at least [download it](https://github.com/AbhiAgarwal/prototyping-django) and be able to run it. This tutorial is going to be relying on the API that we wrote. We're going to be building an iOS app using react-native that displays all the events that are happening. The list of events will be served from the REST API that we built using Django.

So! What is React Native? The React Native website describes it as "a framework for building native apps using React". The basic idea is that we're able to write iOS applications using Javascript and the [React framework](https://facebook.github.io/react/) that Facebook has built. You must be thinking - why shouldn't I just learn native iOS development using Swift or Objective-C? My answer to that is: Well! We're just prototyping. Sure you could prototype using Swift or Objective-C, but in my experience it has been harder to learn Xcode and Swift while also prototyping an app and building an API. The fact that I can write Javascript and use NPM packages to build an iOS app is magical! We don't need blazing-speed when we're prototyping - we need to get something out the door and get something to test with! Build an MVP. I got started using React Native when I was prototyping, and I was able to get something out the door in just two days! This was just using the React Native documentation and some sample projects that they had on Github.

Lets get started! Firstly, you must have OS X. This is required for iOS development in general. If you don't - I will release an Android version soon :-). Please follow [this](https://facebook.github.io/react-native/docs/getting-started.html#requirements) link to setup the requirements. You will also require Xcode as mentioned [here](https://facebook.github.io/react-native/docs/getting-started.html#ios-setup). Next you should run this command:

```
npm install -g react-native-cli
react-native init events-app
```
