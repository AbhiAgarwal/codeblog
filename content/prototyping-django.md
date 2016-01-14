+++
date = "2016-01-31T14:19:00+07:00"
draft = true
title = "Prototyping using Django"

+++

I am writing a series on how to prototype and release a product very fast using just a few tools! This is a three-part tutorial. The first part will be writing an API in Django. The second part will be writing an iOS app using React-native, and the last part will be writing a web app in Angular.JS. These three tools will allow you to prototype and push something out the door very quickly!

Lets get started with writing our API in Django! All you need to know for now is that “Django is a high-level Python Web framework”. If you’re not sure what a web framework is or haven’t built an API in the past then just follow along, and hopefully you’ll get the gist of it!

In this tutorial we’ll be using Python 2.7.10. We're going to be making an app to show a list of events that are happening. Firstly, lets setup a [virtual environment](http://docs.python-guide.org/en/latest/dev/virtualenvs)! Specifically we’ll be using [virtualenvwrapper](http://virtualenvwrapper.readthedocs.org/en/latest/index.html). This allows you to easily switch between virtual environments. If you’ve already setup virtual environments - feel free to use your own and skip this part.

Run these following commands in your Terminal:

```bash
pip install virtualenv
pip install virtualenvwrapper
```

Put these into your `~/.bash_profile`:

```bash
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
```

Now that you have `virtualenvwrapper` installed, you can create a virtual environment by running `mkvirtualenv eventsapp`. `eventsapp` is just the name of the virtual environment - feel free to call it your project name.

After you create this virtual environment you should be inside it! You should see something like this: `(eventsapp)abhiagarwal at Abhis-MacBook-Pro in ~` in your Terminal window. The first part just lets you know which virtual environment you are in. To leave the virtual environment just do `deactivate`, and to go into a virtual environment run `workon eventsapp`.

This is great! Now you have a virtual environment setup. We can start building our Django API! Let's start the Django development! First you'll need to install django in your virtual environment. So stay in the virtual environment you're in, and run `pip install Django==1.9`. This should install Django with the version 1.9. We'll stick with version 1.9 since it's the newest version (at the time this post was written). If you want to look at all the Python packages that are available in your virtual environment you can do a `pip freeze`. Right now when you do run `pip freeze` you should see:

```
Django==1.9
wheel==0.24.0
```

This should have installed a command in your environment called `django-admin`. We're going to be calling our project `today`. This is just the name of your product. Substitute it with whatever you want! We'll put our API in a folder called `today-api`. So go ahead and do `mkdir today-api`, and `cd today-api`. The location of where this is on your computer is not too important as this point.

To start a new Django project you can run `django-admin startproject today`. This will create a directory called today in the folder. At this point you should see the following structure:

```
.
├── events-api
    └── today
        ├── manage.py
        └── today
            ├── __init__.py
            ├── settings.py
            ├── urls.py
            └── wsgi.py
```

Each of these files are responsible for how your Django app will run. Taken from the [Django documentation](https://docs.djangoproject.com/en/1.9/intro/tutorial01/) (which is quite incredible and useful):

* "The outer `today/` root directory is just a container for your project. Its name doesn’t matter to Django; you can rename it to anything you like."
* "`manage.py`: A command-line utility that lets you interact with this Django project in various ways. You can read all the details about manage.py in [django-admin and manage.py](https://docs.djangoproject.com/en/1.9/ref/django-admin/)."
* "The inner `today/` directory is the actual Python package for your project. Its name is the Python package name you’ll need to use to import anything inside it (e.g. today.urls)."
* "`today/__init__.py`: An empty file that tells Python that this directory should be considered a Python package. (Read more about [packages](https://docs.python.org/2/tutorial/modules.html#packages) in the official Python docs if you’re a Python beginner.)"
* "`today/settings.py`: Settings/configuration for this Django project. Django settings will tell you all about how settings work."
* "`today/urls.py`: The URL declarations for this Django project; a “table of contents” of your Django-powered site. You can read more about URLs in [URL dispatcher](https://docs.djangoproject.com/en/1.9/topics/http/urls/)."
* "`today/wsgi.py`: An entry-point for WSGI-compatible web servers to serve your project. See [How to deploy with WSGI](https://docs.djangoproject.com/en/1.9/howto/deployment/wsgi/) for more details."

Especially when you're prototyping you don't want to reinvent the wheel. So we're going to be replying on a couple Python packages that will help us accelerate our development. First of all we're going to be setting up the structure of our application. This is where we begin using some Django best practices.

To initially run your Django app you can `cd today`, and run `./manage.py runserver`. It should alert you by saying that "you have unapplied migrations; your app may not work properly until they are applied". This is Django telling you that you basically have to run database migrations. You can simply follow what Django tells you to do and run `python manage.py migrate`. This is interchangeable with `./manage.py migrate`. Basically what this means is that Django is importing the necessary models at the beginning into your database. Initially, Django uses SQLite. So when you run the migrations you should see `db.sqlite3` in your directory. We're going to be switching to using another database later on, but for now we'll stick with SQLite.

Now you should be able to run your Django app. Run it, and visit `http://127.0.0.1:8000/` on your computer. When you visit this URL you should see `It worked!` at the beginning! Congrats! You've managed to run your Django web server. Whatever happens next -- you've still managed to run your Django application!

## Adding apps

The main folder in your Django project (called `today`) is called a project. Now we have to add `apps` (applications). These apps are the smaller modules in your Django application that represent what you're building. Let's set up our apps folder:

```
$ cd today
$ mkdir apps
$ cd apps
$ touch __init__.py
$ mkdir events
$ cd events
$ touch __init__.py
```

Now your directory structure should look like this:

```
.
├── events-api
    └── today
        ├── db.sqlite3
        ├── manage.py
        └── today
            ├── __init__.py
            ├── apps
            │   ├── __init__.py
            │   └── events
            │       └── __init__.py
            ├── settings.py
            ├── urls.py
            └── wsgi.py
```

Great! Now we've setup an app called `events` in our project. This will be the app in which we write the logic for our Events API. First, create a file called `models.py` in the folder `events`. You can do this by doing `touch models.py`. In that folder we're going to be writing the logic for our Event model. A model can be seen as a grouping of different methods and variables. If you have not encountered Object Oriented Programming before then don't worry! Our Event model is just a blueprint for how we will save and load data from the database. In the file `models.py` paste this following code:

```python
# -*- coding: utf-8 -*-
from django.db import models


class Event(models.Model):
    name = models.TextField(blank=False, max_length=100)
    description = models.TextField(blank=False, max_length=1000)
    date = models.DateTimeField(blank=False, null=False)

    def __unicode__(self):
        return self.name
```

We initially have two fields in our model. The first one is called `name`, and the second one is called `description`, and the third one is called `date`. The name and description field are of type `TextField`. Django comes with "batteries installed", which means that it provides us with a lot of things we can just start using. The date field is of type `DateTimeField`. We can pass in certain parameters into these fields. In the name field we pass in:

- `blank=False` -- which means that it can't be blank -- it's not an optional field
- `max_length=100` -- the name of the event can be at most 100 characters.

In the date field we pass in:

- `null=False` --

Here we've setup a basic model for a single event. Each event must have a name, a description, and a date. We should also go ahead and add an `image` field. An event could have an image! Underneath date you should add:

`image = models.URLField(blank=True, max_length=500)`

This uses the `URLField` that is built into Django. This is different from `TextField` because it internally validates and makes sure the URL is of correct format when you add it. Here we use `blank=True`, which means that image is an optional field. When we're adding a new event we might not have an image for it -- the optional part makes it so we don't have too.

Great! So we've added our basic model. Now, add a file called `admin.py` by doing `touch admin.py`. Django comes built in with an admin interface where you're able to see all the data in your models. This file tells Django to add your model to the admin interface. In this file you should go ahead and just add:

```python
# -*- coding: utf-8 -*-
from django.contrib import admin

from .models import Event

admin.site.register(Event)
```

Now that we've added our models, and admin files we will begin to start building our API views. First we've to add a Django package and configure it. We're going to be using Django Rest Framework, which makes it easy to build REST APIs. Go ahead and run this (in your virtual environment):

`pip install djangorestframework==3.3.2`

At this point we should create a `requirements.txt` file. This will allow you to track the Python packages you've installed. Go back to the base `events-api` folder. Then run `touch requirements.txt`. Now you're able to use `pip freeze`, and put the output into requirements.txt. To do this just execute the command `pip freeze > requirements.txt`. This should put your current Python packages into the file. To view the file you can just run `cat requirements.txt` in your Terminal. You should see:

```
Django==1.9
wheel==0.24.0
djangorestframework==3.3.2
<more>
```

Having your requirements in a file is important. In the future to install your requirements you're simply able to do `pip install -r requirements.txt`.

## Setting up settings.py



## Sources

- [Django documentation](https://docs.djangoproject.com/en/1.9/)
