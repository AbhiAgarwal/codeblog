+++
date = "2016-01-10T14:19:00+07:00"
draft = false
title = "Using CircleCI to automate builds"

+++

Using Continuous Integration has shown to be incredibly powerful - especially when you combine it with Github/Bitbucket/any version control platform. CircleCI/TravisCI/Jenkins and any other CI frameworks allow programmers to automatically deploy, and test their code on a **clean environment**. The clean environment part is important as sometimes programmers have different dependencies on their own machines and on their servers. This becomes a problem as it breaks deployments, and causes programming errors in the future. The CI platforms give programmers the ability to test their code in a controlled environment before deploying it onto their own servers. The CI platforms takes care of installing the dependencies programmatically on this staging server, and in a way it acts as a middleman.

Even if you are building a library it becomes useful as you can run your tests and make sure your library builds under this clean environment. As you get more collaborators for your projects you can make sure the additions they make run in this environment and not just on their own computers.

This is just one benefit CI platforms have. There’s a ton of benefits:

*   Automate builds and deployment.
*   Running tests (bug detection!)
*   Everyone is able to monitor the builds.
*   Metrics can be generated on how long builds take, how complex the code is, and many other things. It helps make it easy to notice what the flaws in the process are.
*   It’s ruthless because the task is being done by the machine. If it encounters an error in the build it’ll halt rather than deploying it anyways.

There’s also costs associated with CI platforms:

*   Usually rely on a complex platform. This reduces flexibility over using [Fabric](http://fabfile.org/) or some other method of deployment (they can also be used in conjunction).
*   You don’t always have complete control over all the packages that they install. They use their own base image for the OS that you can’t overwrite (can be solved if you use Jenkins or any other CI solution in-house).

*   It’s expensive if you want parallelism or any type of extra features.

It’s incredible simple to get started with a CI platform as well! CircleCI is one I love using because it’s easy to get started + they allow developers to use private repositories (rather than TravisCI where you have to pay for a private repository). 

To get started you can go on [circleci.com](http://circleci.com) and login through your Github (or Bitbucket, etc). Then you can just add the repositories you want to add CircleCI to by visiting the “Add Projects” section. Now your repository to be built automatically when you push any new commits to it on Github. Before you start pushing code - you’ve to do one final thing. You’ve to add a file called circle.yml. This file tells CircleCI what it’s supposed to do when you push to the master branch of your repository.

An example of a circle.yml file is below:
<script src="https://gist.github.com/AbhiAgarwal/ce90915c99120a986a7e.js"></script>

This is a simple circle.yml document that builds a jekyll website and then uploads it to Rackspace Cloud Files. Let’s look through the code:

*   The general section at the top is to give CircleCI information about your branches and many other settings. 
*   The machine setting tells CircleCI which timezone, OS, programming language versions (etc) you want to use. These are settings on how it should spin up the virtual machine.
*   The next is dependencies. It tells CircleCI the software dependencies you need to install. There’s 3 settings within dependencies: pre, overwrite, and post. We’re using post in this script which means install these gems after CircleCI has ran it’s own dependency commands. Pre is before CircleCI runs it’s own dependency commands, and overwrite basically means run these instead of CircleCI’s. 
*   The test section is just to tell CircleCI how to run your tests!
*   The last is deployment. You can tell CircleCI how to deploy each of the branches you want CircleCI to run on. Here I’m using [turbolift](https://github.com/cloudnull/turbolift) to upload files to Rackspace Cloud Files. The values starting with $ are just environment variables that you’re able to set through the Project Settings section of CircleCI.

There’s more documentation [here](https://circleci.com/docs/configuration). You can do a lot using CircleCI. They have a lot of interesting documentation. I’ve used it for all sorts of scenarios. You can run node scripts, python scripts, and automate pretty much anything that you can do through your command line. I have also added some examples of circle.yml files (that we use in production at [Tech@NYU](http://github.com/techatnyu)) [here](https://gist.github.com/AbhiAgarwal/6e45a81375cf6d3eddf9).
