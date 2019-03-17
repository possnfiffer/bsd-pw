# This is how I install Python on FreeBSD and get it ready to follow along with online tutorials.

## Aquire Python 3.7 and Pipenv for managing virtual environments and installing packages via pip

```sudo pkg install -y python37```

```sudo -H python3.7 -m ensurepip```

```sudo -H pip3.7 install --upgrade pip```

```sudo -H pip3.7 install pipenv```

## Regular Python usage commands
```pipenv install **b2**```

(or any package name works fine here in place of b2)
pipenv will create the virtualenv for you and install whatever package into it.

Alternatively you can just use

```pipenv shell```

to create a virtualenv and open the shell within it so you could type something normal like

```pip install b2```

which will install the b2 client for BackBlaze B2 which I use for off-site backups.

I've heard poetry is cool and similar to pipenv but haven't started using that one.
