sudo xcode-select -s /Applications/Xcode-beta.app/Contents/Developer

mkdir MySite
cd MySite
swift package init --type executable
swift build
swift run

python -m http.server --directory www
