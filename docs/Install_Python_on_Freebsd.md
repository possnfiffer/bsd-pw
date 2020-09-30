# This is how I install Python on FreeBSD and get it ready to follow along with online tutorials.

## Aquire Python 3.8 and Pipenv for managing virtual environments and installing packages via pip

```sudo pkg install -y python38```

```sudo -H python3.8 -m ensurepip```

```sudo -H pip3.8 install --upgrade pip setuptools```

```sudo -H pip3.8 install pipenv```

## A final configuration step is to setup UTF-8 on FreeBSD. If you haven't already done so check the instructions in the Intro to FreeBSD Workshop linked below
[Intro to FreeBSD](https://github.com/possnfiffer/bsd-pw/blob/gh-pages/docs/Intro_to_FreeBSD_Workshop.md#iocage)

## Python with pipenv usage commands
```pipenv install b2```

(or any package name works fine here in place of b2)
pipenv will create the virtualenv for you and install whatever package into it.

Alternatively you can just use

```pipenv shell```

to create a virtualenv and open the shell within it so you could type something normal like

```pip install b2```

which will install the b2 client for BackBlaze B2 which I use for off-site backups but it won't save these to the Pipfile so I recommend the pipenv install way for ease of use and the regular venv module for automated deployment use case.

Also, pipenv uses a Pipfile rather than requirements.txt so you can import a requirements.txt file like

```pipenv install -r requirements.txt```


## Regular Python venv module usage commands
```python3.8 -m venv venv```

```source venv/bin/activate.csh```

```pip install --upgrade pip setuptools```

```pip install b2```

```pip install -r requirements.txt```

```deactivate to exit virtualenv```

### Once you have your requirements installed...

Everyday usage looks like this

```pipenv shell```

from within your project directory that contains the Pipfile

```python```

and you'll see your >>> Python repl, enjoy!

### This works too for some projects that have setup.py
```
pipenv install -e project_dir/
pipenv shell
cd project_dir/
python setup.py develop
```
