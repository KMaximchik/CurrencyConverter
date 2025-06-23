if [[ "$(uname -m)" == arm64 ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

if which swiftlint >/dev/null; then
    swiftlint lint –config ./.swiftlint.yml
else
    echo "warning: SwiftLint not installed"
    exit 1
fi