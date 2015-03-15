# reuse-lang
![version](http://img.shields.io/badge/version-0.1.0-blue.svg) [![Public Domain](http://img.shields.io/badge/public%20domain%3F-yes-blue.svg)](http://creativecommons.org/publicdomain/zero/1.0/) [![SemVer](http://img.shields.io/badge/SemVer-2.0.0-blue.svg)](http://semver.org/spec/v2.0.0.html) ![development stage](http://img.shields.io/badge/development%20stage-alpha-orange.svg)

reuse-lang is a pure functional Lisp-like language for writing reusable business-logic in an extremely portable way.

## Design rationale

**Q. Why a Lisp?**

**A.** It makes for a small core language and thus makes the implementation of that language small.

**Q. Why a pure functional language?**

**A.** Having no side-effects should make it trivial to translate to other languages.

**Q. But then how do I do ___?**

**A.** You don't. Reuse is not a general-purpose language. It's meant for creating reuseable libraries that implement business logic. If you need side-effects, you will have to rely on the host language.

## Use
```
node reuse.js < example.reuse
```

#### Target platforms
publicdash.js is written using node.js-style modules.

| Target Host   | Build Status | Built Configurations | Node.js Versions   |
| :------------ | :----------: | :------------------- | :----------------- |
| linux-gcc | [![travis-ci build status](https://travis-ci.org/redien/reuse-lang.svg?branch=master)](https://travis-ci.org/redien/reuse-lang) | x64 | 0.10, 0.11 |

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

reuse-lang - a pure functional lisp-like language for writing reusable business-logic in an extremely portable way.

Written in 2015 by Jesper Oskarsson jesosk@gmail.com

To the extent possible under law, the author(s) have dedicated all copyright
and related and neighboring rights to this software to the public domain worldwide.
This software is distributed without any warranty.

You should have received a copy of the CC0 Public Domain Dedication along with this software.
If not, see <[http://creativecommons.org/publicdomain/zero/1.0/](http://creativecommons.org/publicdomain/zero/1.0/)>.
