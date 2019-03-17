# This is how I install Python on FreeBSD and get it ready to follow along with online tutorials.

## Aquire Python 3.7 and Pipenv for managing virtual environments and installing packages via pip

```sudo pkg install -y python37```

```sudo -H python3.7 -m ensurepip```

```sudo -H pip3.7 install --upgrade pip```

```sudo -H pip3.7 install pipenv```

## A final configuration step is to setup UTF-8 on FreeBSD. If you haven't already done so check the instructions in the Intro to FreeBSD Workshop linked below
[Intro to FreeBSD](https://github.com/possnfiffer/bsd-pw/blob/gh-pages/docs/Intro_to_FreeBSD_Workshop.md#iocage)

## Regular Python usage commands
```pipenv install b2```

(or any package name works fine here in place of b2)
pipenv will create the virtualenv for you and install whatever package into it.

Alternatively you can just use

```pipenv shell```

to create a virtualenv and open the shell within it so you could type something normal like

```pip install b2```

which will install the b2 client for BackBlaze B2 which I use for off-site backups but it won't save these to the Pipfile so I recomment the pipenv install way.

Also, pipenv uses a Pipfile rather than requirements.txt so you can import a requirements.txt file like

```pipenv install -r requirements.txt```

### Once you have your requirements installed...

Everyday usage looks like this

```pipenv shell```

from within your project directory that contains the Pipfile

```python```

and you'll see your >>> python repl, enjoy!

I've heard poetry is cool and similar to pipenv but haven't started using that one.
