#!/bin/bash

set -eo pipefail

xcodebuild -workspace Example/Clavier.xcworkspace \
            -scheme Clavier-Example \
            -destination platform=iOS\ Simulator,OS=14.5,name=iPhone\ 11 \
            clean test | xcpretty
