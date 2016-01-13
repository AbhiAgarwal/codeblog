+++
date = "2016-01-31T14:19:00+07:00"
draft = true
title = "Prototyping using Django"

+++

I am writing a series on how to prototype and release a product very fast using just a few tools! This is a three-part tutorial. The first part will be writing an API in Django. The second part will be writing an iOS app using React-native, and the last part will be writing a web app in Angular.JS. These three tools will allow you to prototype and push something out the door very quickly!

Lets get started with writing our API in Django! All you need to know for now is that “Django is a high-level Python Web framework”. If you’re not sure what a web framework is or haven’t built an API in the past then just follow along, and hopefully you’ll get the gist of it!

In this tutorial we’ll be using Python 2.7.10. We're going to be making an app to show a list of contacts that a user has. Firstly, lets setup a [virtual environment](http://docs.python-guide.org/en/latest/dev/virtualenvs)! Specifically we’ll be using [virtualenvwrapper](http://virtualenvwrapper.readthedocs.org/en/latest/index.html). This allows you to easily switch between virtual environments. If you’ve already setup virtual environments - feel free to use your own and skip this part.

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

Now that you have `virtualenvwrapper` installed, you can create a virtual environment by running `mkvirtualenv djangoapp`. `djangoapp` is just the name of the virtual environment - feel free to call it your project name.

After you create this virtual environment you should be inside it! You should see something like this: `(djangoapp)abhiagarwal at Abhis-MacBook-Pro in ~` in your Terminal window. The first part just lets you know which virtual environment you are in. To leave the virtual environment just do `deactivate`, and to go into a virtual environment run `workon djangoapp`.

This is great! Now you have a virtual environment setup. We can start building our Django API! Let's start the Django development! First you'll need to install django in your virtual environment. So stay in the virtual environment you're in, and run `pip install Django==1.9`. This should install Django with the version 1.9. We'll stick with version 1.9 since it's the newest version (at the time this post was written). If you want to look at all the Python packages that are available in your virtual environment you can do a `pip freeze`. Right now when you do run `pip freeze` you should see:

```
Django==1.9
wheel==0.24.0
```

This should have installed a command in your environment called `django-admin`. To start a new Django project you can run `django-admin startproject contacts`. This will create a directory called contacts in the folder. When you `cd` into contacts you should see the following structure:

```
.
├── contacts
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
└── manage.py
```

Each of these files are responsible for how your Django app will run. Taken from the [Django documentation](https://docs.djangoproject.com/en/1.9/intro/tutorial01/) (which is quite incredible and useful):

* "The outer `contacts/` root directory is just a container for your project. Its name doesn’t matter to Django; you can rename it to anything you like."
* "`manage.py`: A command-line utility that lets you interact with this Django project in various ways. You can read all the details about manage.py in [django-admin and manage.py](https://docs.djangoproject.com/en/1.9/ref/django-admin/)."
* "The inner `contacts/` directory is the actual Python package for your project. Its name is the Python package name you’ll need to use to import anything inside it (e.g. contacts.urls)."
* "`contacts/__init__.py`: An empty file that tells Python that this directory should be considered a Python package. (Read more about [packages](https://docs.python.org/2/tutorial/modules.html#packages) in the official Python docs if you’re a Python beginner.)"
* "`contacts/settings.py`: Settings/configuration for this Django project. Django settings will tell you all about how settings work."
* "`contacts/urls.py`: The URL declarations for this Django project; a “table of contents” of your Django-powered site. You can read more about URLs in [URL dispatcher](https://docs.djangoproject.com/en/1.9/topics/http/urls/)."
* "`contacts/wsgi.py`: An entry-point for WSGI-compatible web servers to serve your project. See [How to deploy with WSGI](https://docs.djangoproject.com/en/1.9/howto/deployment/wsgi/) for more details."

## Sources

- [Django documentation](https://docs.djangoproject.com/en/1.9/)
