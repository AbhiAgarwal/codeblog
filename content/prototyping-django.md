+++
date = "2016-01-20T14:19:00+07:00"
draft = false
title = "Prototyping using Django"

+++

I am writing a series on how to prototype and release a product very fast using just a few tools! This is a three-part tutorial. The first part will be writing an API in Django. The second part will be writing an iOS app using React-native, and the last part will be writing a web app in Angular.JS. These three tools will allow you to prototype and push something out the door very quickly!

----------

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

Now that you have `virtualenvwrapper` installed, you can create a virtual environment by running `mkvirtualenv <project_name>`. We're going to be calling our project `today`. This is just the name of your product. Substitute it with whatever you want! `todayapp` is just the name of the virtual environment - feel free to call it your project name. So go ahead and run:

```bash
mkvirtualenv todayapp
```

After you create this virtual environment you should be inside it! You should see something like this: `(todayapp)abhiagarwal at Abhis-MacBook-Pro in ~` in your Terminal window. The first part just lets you know which virtual environment you are in. To leave the virtual environment just do `deactivate`, and to go into a virtual environment run `workon todayapp`.

This is great! Now you have a virtual environment setup. We can start building our Django API! Let's start the Django development! First you'll need to install django in your virtual environment. So stay in the virtual environment you're in, and run:

```bash
pip install Django==1.9
```

This should install Django with the version 1.9. We'll stick with version 1.9 since it's the newest version (at the time this post was written). If you want to look at all the Python packages that are available in your virtual environment you can do a `pip freeze`. Right now when you do run `pip freeze` you should see:

```bash
Django==1.9
wheel==0.24.0
```

This should have installed a command in your environment called `django-admin`. We'll put our API in a folder called `today-api`. So go ahead and do:

```bash
mkdir today-api
cd today-api
```

The location of where this is on your computer is not too important as this point. To start a new Django project you can run:

```bash
django-admin startproject today
```

This will create a directory called today in the folder. At this point you should see the following structure:

```
.
├── today-api
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
└── today-api
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

We initially have three fields in our model. The first one is called `name`, and the second one is called `description`, and the third one is called `date`. The name and description field are of type `TextField`. Django comes with "batteries installed", which means that it provides us with a lot of things we can just start using. The date field is of type `DateTimeField`. We can pass in certain parameters into these fields. In the name field we pass in:

- `blank=False` -- which means that it can't be blank -- it's not an optional field
- `max_length=100` -- the name of the event can be at most 100 characters.

In the date field we pass in:

- `null=False` -- Will not set the value to be NULL in your database. "Blank values for Django field types such as DateTimeField or ForeignKey will be stored as NULL in the DB" ([ref](http://stackoverflow.com/questions/8609192/differentiate-null-true-blank-true-in-django)).

Here we've setup a basic model for a single event. Each event must have a name, a description, and a date. We should also go ahead and add an `image` field. An event could have an image! Underneath date you should add:

`image = models.URLField(blank=True, max_length=500)`

This uses the `URLField` that is built into Django. This is different from `TextField` because it internally validates and makes sure the URL is of correct format when you add it. Here we use `blank=True`, which means that image is an optional field. When we're adding a new event we might not have an image for it -- the optional part makes it so we don't have too. The final product should look like this:

```python
# -*- coding: utf-8 -*-
from django.db import models


class Event(models.Model):
    name = models.TextField(blank=False, max_length=100)
    description = models.TextField(blank=False, max_length=1000)
    date = models.DateTimeField(blank=False, null=False)
    image = models.URLField(blank=True, max_length=500)

    def __unicode__(self):
        return self.name
```

Great! So we've added our basic model. Now, add a file called `admin.py` by doing `touch admin.py`. Django comes built in with an admin interface where you're able to see all the data in your models. This file tells Django to add your model to the admin interface. In this file you should go ahead and just add:

```python
# -*- coding: utf-8 -*-
from django.contrib import admin

from .models import Event

admin.site.register(Event)
```

Now that we've added our models, and admin files we will begin to start building our API views. First we've to add a Django package and configure it. We're going to be using Django Rest Framework, which makes it easy to build REST APIs. Go ahead and run this (in your virtual environment):

`pip install djangorestframework==3.3.2`

At this point we should create a `requirements.txt` file. This will allow you to track the Python packages you've installed. Go back to the base `today-api` folder. Then run `touch requirements.txt`. Now you're able to use `pip freeze`, and put the output into requirements.txt. To do this just execute the command `pip freeze > requirements.txt`. This should put your current Python packages into the file. To view the file you can just run `cat requirements.txt` in your Terminal. You should see:

```
Django==1.9
djangorestframework==3.3.2
wheel==0.24.0
```

Having your requirements in a file is important. In the future to install your requirements you're simply able to do `pip install -r requirements.txt`. Your directory should finally look like this now:

```
.
└── today-api
    ├── requirements.txt
    └── today
        ├── db.sqlite3
        ├── manage.py
        └── today
            ├── __init__.py
            ├── apps
            │   ├── __init__.py
            │   └── events
            │       ├── __init__.py
            │       ├── admin.py
            │       └── models.py
            ├── settings.py
            ├── urls.py
            └── wsgi.py
```

## Setting up settings.py

Now open up your `settings.py` file. It should be in the same directory as the `apps` folder is. In the `settings.py` file you should see a variable called `INSTALLED_APPS`. This is what governs what apps Django runs for you when you do `./manage.py runserver`. We have to add our new apps to it. To this we will add `'rest_framework'`, and `'today.apps.events'`. Django paths are set relative to folder `manage.py` is in. So your files will all be relative to the folder `today`. The `urls.py` file will be `today.urls`, etc. Lets now change the `INSTALLED_APPS` to:

```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'today.apps.events',
]
```

## Making migrations

Now we have to do something exciting. We have to run migrations! So now that you've created an Event model we have to take the schema you wrote, and make Django make a Table for that in the database. You've virtually constructed this Model with fields, but now how are we going to mirror this structure in the database? Well! Django comes built in with these tools. Run `./manage.py makemigrations events`. The `events` is which specific app we are talking about. When you run this -- it should return:

```python
Migrations for 'events':
  0001_initial.py:
    - Create model Event
```

If it prints something different then you've made a mistake somewhere. This command just creates the migrations. It creates a folder called `migrations` (which you should not remove!) inside your `apps/events` folder, and creates a python file inside it with the specifics of your schema. Now you should run `./manage.py migrate events`. This should return:

```python
Operations to perform:
  Apply all migrations: events
Running migrations:
  Rendering model states... DONE
  Applying events.0001_initial... OK
```

This means that we've successfully taken our schema and added these fields into the database. Whenever you add a new field to your model -- you should always make a migration (using `makemigrations`), and then migrate it (using `migrate`). Django makes it very very easy to do these things. Traditionally you'd have to go through a lot of pain to add new fields to your database -- specifically if you were dealing with SQL databases. The Django ORM is very much batteries included.

## Writing our first ViewSet

A ViewSet in Django Rest Framework is defined as "Django REST framework allows you to combine the logic for a set of related views in a single class, called a ViewSet. In other frameworks you may also find conceptually similar implementations named something like 'Resources' or 'Controllers'" ([ref](http://www.django-rest-framework.org/api-guide/viewsets/)).

Let's go back into our events app. Just `cd` into it. Here create a file called `views.py`. This is the file that is incharge of handling what happens when something tries to reach your events endpoint. Here you should put:

```python
# -*- coding: utf-8 -*-
from .models import Event
from .serializers import EventSerializer
from rest_framework import viewsets


class EventsViewSet(viewsets.ModelViewSet):
    serializer_class = EventSerializer

    def get_queryset(self,):
        queryset = Event.objects.all()
        uid = self.kwargs.get('pk')
        if uid:
            return queryset.filter(pk=uid)
        else:
            return queryset
```

This is a ViewSet. Basically when a request comes it -- it calls `get_queryset` to get a `queryset`, which is what it has to return. A queryset can just be seen as an array of instances of the `Event` model. When you do `/events` you want it to return all the events, but when you do `/events/1` you want it to return the event of `id` 1. In Django this `id` is called `pk` or primary key. So we're checking to see if `uid` is not None, and if it is not we want to filter the queryset and return the event with that ID.

Now we have to write a Serializer. A Serializer in Django Rest Framework is defined as "Serializers allow complex data such as querysets and model instances to be converted to native Python datatypes that can then be easily rendered into JSON, XML or other content types. Serializers also provide deserialization, allowing parsed data to be converted back into complex types, after first validating the incoming data" ([ref](http://www.django-rest-framework.org/api-guide/serializers/)).

```python
# -*- coding: utf-8 -*-
from .models import Event
from rest_framework import serializers


class EventSerializer(serializers.HyperlinkedModelSerializer):

    def to_representation(self, obj):
        return {
            'id': obj.pk,
            'name': obj.name,
            'description': obj.description,
            'date': obj.date,
            'image': obj.image,
        }

    class Meta:
        model = Event
        fields = ('name', 'description', 'date', 'image',)
```

## Setting up our URLs

We've now finished our ViewSet and our Serializer! Now we can finally go ahead and preview our API. But first, we have to set up our `urls.py` file! Change directories into the `apps` folder. In the `apps` folder write a file called `router.py`. In this file you can put:

```python
# -*- coding: utf-8 -*-
from rest_framework import routers
from today.apps.events.views import EventsViewSet

router = routers.DefaultRouter()
router.register(r'events', EventsViewSet, base_name='event')
```

In the `urls.py` file put:

```
# -*- coding: utf-8 -*-
from django.conf.urls import include, url
from django.contrib import admin

from today.apps.router import router

urlpatterns = [
    url(r'^admin/', include(admin.site.urls)),
    url(r'^api/', include(router.urls)),
]
```

Now you can start up your application. `./manage.py runserver`. In your browser visit `http://localhost:8000/api/events/`. This is your API! When you open this on incognito you should be able to your API, and make a GET request to get all your events data. If you want to format it as JSON try visit this url -- `http://localhost:8000/api/events/?format=json`. When you push things into production you can make this format by default. Django Rest Framework provides this clean user interface to allow you to play around with your data easily. Try and add some data! When you visit `http://localhost:8000/api/events/` at the bottom there should be an area called `HTML form`. Here you can add data. Here's some sample data:

```
Name: Party on Broadway
Description: There's a party on Broadway!
Date: 01/20/2016, 12:00 PM
```

Or if you want to create it through `Raw data`:

```json
{
    "name": "Party on Broadway",
    "description": "There's a party on Broadway!",
    "date": "2016-01-20T12:00:00Z",
    "image": ""
}
```

This should return:

```
HTTP 201 Created
Allow: GET, POST, HEAD, OPTIONS
Content-Type: application/json
Vary: Accept

{
    "date": "2016-01-20T12:00:00Z",
    "description": "There's a party on Broadway!",
    "id": 1,
    "image": "",
    "name": "Party on Broadway"
}
```

Now when you visit the `/api/events` API endpoint -- you should see:

```
HTTP 200 OK
Allow: GET, POST, HEAD, OPTIONS
Content-Type: application/json
Vary: Accept

[
    {
        "date": "2016-01-20T12:00:00Z",
        "description": "There's a party on Broadway!",
        "id": 1,
        "image": "",
        "name": "Party on Broadway"
    }
]
```

Now we have to work on some permissions. Anyone can currently add data to the API endpoint right now. Django Rest Framework comes with a permissions framework that allows us to fix this very easily! Go back to the `settings.py` file, and add a new variable to it:

```python
REST_FRAMEWORK = {
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.IsAuthenticatedOrReadOnly'
    ]
}
```

Django Rest Framework has a bunch of settings that you can use here. It also has a permissions framework for each model. So you can declare and customize your own permissions depending on each model. For example, if you have user profiles you can customize permissions for the user to be able to edit their own permissions, but not others. After you add this line -- you should no longer be able to add events. Now you'll have to create a super user in Django, and use the `admin` feature! Run the following command:

```
./manage.py createsuperuser
```

And follow the details. It should ask you:

```
Username (leave blank to use 'abhi'): abhi
Email address: hi@abhi.co
Password: xxxxxxx1
Password (again): xxxxxxx1
```

Now visit `http://localhost:8000/admin/`, and fill in your details. Now you should see the `admin` panel. You should see `Groups`, `Users`, and `Events`. Here you can create, read, updated or delete new events, groups, or users. When you add new models you should see them appear here as well! If you visit the `Events` section you should see the "Party on Broadway" event there. You should be able to create, read, updated or delete it!

When you visit `http://localhost:8000/api/events/` now -- you should be able to add an event again! When you open it on incognito you won't be able to add an event. That's great! This is very basic security, and you can definitely do better.

Moreover, you should also be able to visit `http://localhost:8000/api/events/1`, and see only the event with `id` = 1. We've managed to create a very simple REST API with a single endpoint.

Your finally directory structure would be:

```
.
└── today-api
    ├── requirements.txt
    └── today
        ├── db.sqlite3
        ├── manage.py
        └── today
            ├── __init__.py
            ├── apps
            │   ├── __init__.py
            │   ├── events
            │   │   ├── __init__.py
            │   │   ├── admin.py
            │   │   ├── migrations
            │   │   │   ├── 0001_initial.py
            │   │   │   └── __init__.py
            │   │   ├── models.py
            │   │   ├── serializers.py
            │   │   └── views.py
            │   └── router.py
            ├── settings.py
            ├── urls.py
            └── wsgi.py
```

In the next Prototyping tutorial, we will go through how to hook up this REST API made using Django with a React Native iOS app!

## Sources

- [Django documentation](https://docs.djangoproject.com/en/1.9/)
