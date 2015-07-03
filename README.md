# reuse-lang
![version](http://img.shields.io/badge/version-0.1.0-blue.svg) [![Public Domain](http://img.shields.io/badge/public%20domain%3F-yes-blue.svg)](http://creativecommons.org/publicdomain/zero/1.0/) [![SemVer](http://img.shields.io/badge/SemVer-2.0.0-blue.svg)](http://semver.org/spec/v2.0.0.html) ![development stage](http://img.shields.io/badge/development%20stage-alpha-orange.svg)

reuse-lang is a pure functional Lisp-like language for writing reusable algorithms in an extremely portable way.

## Design rationale

The goal is for the language and compiler to have the following properties:
- **Be easy to understand and make changes to.** (And thus have a tiny code base compared to other language implementations.)
- **Be available on as many platforms as possible.** (By making it simple to add new target platforms and languages, in order to allow the reuse of the same algorithms everywhere.)
- **Reducing the surface area for bugs by reducing the complexity for the majority of code we use.** (Writing algorithms in a pure functional language reduces complexity by removing side-effects from the equation.)
- **Optimize for speed and memory usage only when it doesn't conflict with the above mentioned points.**

The goal is **not** to do any of the following:
- **Create a general-purpose language.** (The idea is to use the generated libraries in a host language and handle any side-effects etc. there.)
- **Re-invent Haskell.** (Haskell does Haskell really well already.)

## Use
```
node reuse.js < example.reuse
```

#### Target platforms
| Target Host   | Build Status | Built Configuration |
| :------------ | :----------: | :------------------: |
| linux-gcc | [![travis-ci build status](https://travis-ci.org/redien/reuse-lang.svg?branch=master)](https://travis-ci.org/redien/reuse-lang) | x64, Node.js 0.10 |
| linux-gcc | [![travis-ci build status](https://travis-ci.org/redien/reuse-lang.svg?branch=master)](https://travis-ci.org/redien/reuse-lang) | x64, Node.js 0.11 |

## Development
[![devDependencies](https://david-dm.org/redien/reuse-lang/dev-status.svg)](https://david-dm.org/redien/reuse-lang#info=devDependencies)

Fork the project and install dependencies:
```
npm install -g mocha
npm install
```

#### Test
reuse-lang performs testing using mocha and should.js.

```
npm test
```

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
