#!/usr/bin/env bash

if which git-lfs >/dev/null; then
    echo "git-lfs already installed"
else
    brew install git-lfs
fi

if which swiftlint >/dev/null; then
    echo "Swiftlint already installed"
else
    brew install swiftlint
fi

(cd "$( dirname "$0")"; xcodegen)
open "$( cd "$( dirname "$0" )" && pwd )"/CurrencyConverter.xcodeproj
