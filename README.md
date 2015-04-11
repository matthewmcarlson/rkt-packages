rkt-packages
=============

A makefile to download rkt and make a package out of it.

## Requirements

The ever so handy [fpm](https://github.com/jordansissel/fpm)

## Usage

    make deb

or

    ITERATION=custom2 make deb

## Bugs

RPM is untested. stage1.aci is just dropped into /usr/bin?
