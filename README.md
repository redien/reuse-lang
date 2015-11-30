# reuse-lang
![version](http://img.shields.io/badge/version-0.1.0-blue.svg) [![Public Domain](http://img.shields.io/badge/public%20domain%3F-yes-blue.svg)](http://creativecommons.org/publicdomain/zero/1.0/) [![SemVer](http://img.shields.io/badge/SemVer-2.0.0-blue.svg)](http://semver.org/spec/v2.0.0.html) ![development stage](http://img.shields.io/badge/development%20stage-alpha-orange.svg)

reuse-lang is a pure functional Lisp-like language for writing reusable algorithms in an extremely portable way.

## Use
```
node reuse.js example.reuse
```

#### Target platforms
| Target Hosts   | Node.js versions | Build Status |
| :------------ | :----------: | :------------------: |
| linux-gcc, osx | 0.10, 0.11, 0.12, iojs, 4.0, 4.1, 4.2, 5.1 | [![travis-ci build status](https://travis-ci.org/redien/reuse-lang.svg?branch=master)](https://travis-ci.org/redien/reuse-lang) |

## Design rationale

The goal is for the language and compiler to have the following properties:
- **Be easy to understand and make changes to.** And thus have a tiny code base compared to other language implementations.
- **Be available on as many platforms as possible.** By making it simple to add new target platforms and languages, in order to allow the reuse of the same algorithms everywhere.
- **Reduce the surface area for bugs.** By removing complexities such as side-effects for the majority of code we use.
- **Optimize for speed and memory usage only when it doesn't conflict with the above mentioned points.**

The goal is **not** to do any of the following:
- **Create a general-purpose language.** The idea is to use the generated libraries in a host language and handle any side-effects etc. there.
- **Re-invent Haskell.** Haskell does Haskell really well already.
- **Write Monte-Carlo simulations.** Optimizing for real-time, simulation-type algorithms is outside the scope and can be done much easier in other languages. (But why not reuse code for things other than the simulation itself?)

## Development
[![devDependencies](https://david-dm.org/redien/reuse-lang/dev-status.svg)](https://david-dm.org/redien/reuse-lang#info=devDependencies)
[![Code Climate](https://d3s6mut3hikguw.cloudfront.net/github/redien/reuse-lang/badges/gpa.svg)](https://codeclimate.com/github/redien/reuse-lang)

Fork the project and install dependencies:
```
npm install
```

then you can run the tests with:

```
npm test
```

#### Bugs/TODO

* Using an imported value from a parent module doesn't produce an error when it wasn't defined in the current module.
* Should produce an error when no values are used from an imported module.

#### Code coverage
[![Coverage Status](https://img.shields.io/coveralls/redien/reuse-lang.svg)](https://coveralls.io/r/redien/reuse-lang?branch=master)

reuse-lang analyzes code coverage using blanket.js. To produce a report, run:
```
npm run-script coverage
```

This will generate a file named `coverage.html` in the project root directory which can be viewed in a browser.

## Copy

reuse-lang - a pure functional lisp-like language for writing reusable algorithms in an extremely portable way.

Written in 2015 by Jesper Oskarsson jesosk@gmail.com

To the extent possible under law, the author(s) have dedicated all copyright
and related and neighboring rights to this software to the public domain worldwide.
This software is distributed without any warranty.

You should have received a copy of the CC0 Public Domain Dedication along with this software.
If not, see <[http://creativecommons.org/publicdomain/zero/1.0/](http://creativecommons.org/publicdomain/zero/1.0/)>.
