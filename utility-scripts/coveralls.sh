
# reuse-lang - a pure functional lisp-like language for writing
# reusable algorithms in an extremely portable way.
#
# Written in 2015 by Jesper Oskarsson jesosk@gmail.com
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain worldwide.
# This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with this software.
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Get the position in the job list
job_version=`echo $TRAVIS_JOB_NUMBER | egrep -o "\.[0-9]$" | egrep -o [0-9]`

# If we're the first job for this build, send coverage information.
# We need to test this as sending the coverage information multiple times
# produces an error in some cases.
if test -z "$job_version" -o "$job_version" = "1"
then
    # Cover tests
    mocha --require blanket -R mocha-lcov-reporter "**/*.unit.js" > javascript-coverage.info

    # Send to coveralls.io
    cat javascript-coverage.info | ./node_modules/coveralls/bin/coveralls.js
fi
