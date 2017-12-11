# CariocaMenu

[![Travis CI](https://img.shields.io/travis/arn00s/cariocamenu_refactor.svg)](https://img.shields.io/travis/arn00s/cariocamenu_refactor.svg)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)
[![Carthage compatible](https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/Hero.svg?style=flat)](http://cocoapods.org/pods/Hero)
![iOS 8.0+](https://img.shields.io/badge/iOS-8.0%2B-blue.svg)
![Swift 4.0+](https://img.shields.io/badge/Swift-4.0%2B-orange.svg)
[![License](https://img.shields.io/cocoapods/l/Hero.svg?style=flat)](https://github.com/arn00s/cariocamenu_refactor/blob/master/LICENSE?raw=true)

## ⚠️ Warning

⚠️ This repository hosts the refactor code. The full working lib is of course still available here :

[**https://github.com/arn00s/cariocamenu**](https://github.com/arn00s/cariocamenu)

## Quicklook

The fastest zero-tap iOS menu

CariocaMenu is a **simple**, **elegant**, **fast** navigation menu for your **iOS** apps.

![](https://raw.githubusercontent.com/arn00s/cariocamenu/master/cariocamenu.gif)

## Features

- [x] Accessible from a single swipe of the left/right screen edge
- [x] Accessible with a tap on the indicator
- [x] Customisable menu indicator
- [x] Menu Item supports image & emoji/text
- [x] Boomerang mode
- [x] Full AutoLayout
- [x] [Complete Technical Documentation](http://arn00s.github.io/cariocamenu/)

## Requirements

- Autolayout
- iOS 9.0+
- Swift 4.0

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/CariocaMenu). (Tag 'CariocaMenu')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/CariocaMenu).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.
- If you **use the control**, contact me to mention your app on this page.

## Installation

### CocoaPods
CariocaMenu is now available on [CocoaPods](http://cocoapods.org).
Simply add the following to your project Podfile, and you'll be good to go.

```ruby
use_frameworks!

pod 'CariocaMenu'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate CariocaMenu into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "arn00s/cariocamenu"
```

Run `carthage` to build the framework and drag the built `TOCOMPLETE` into your Xcode project.

### Manually

If you prefer, you can integrate CariocaMenu into your project manually.

Just Drag&Drop all the files under `Sources/` into your project.

---

## Usage

### Creating your menu

```swift
TOCOMPLETE
```

### Adding it to a view

```swift
TOCOMPLETE
```

### Boomerang

A boomerang always comes back to it's original place.
By default, the boomerang is set to `none`. It means that the menu will stay where the user let it.
The two other boomerang options are :

- `vertical` : Will always come back at the same vertical position, but on the edge the user has chosen.
```swift
TOCOMPLETE
```

- `verticalHorizontal` : Will always come back at the same position (vertical + same screen edge)
```swift
TOCOMPLETE
```

## TODO

- Add a `live tutorial` to indicate users how to get the most of this menu

## Known issues

Check the ([GitHub issues](https://github.com/arn00s/CariocaMenu/issues))

## FAQ

### Why should I use `CariocaMenu`?

You're starting a new iOS app, and you want to innovate on the user experience.

### Why the name `CariocaMenu`?

I didn't want to use the same naming convention that EVERYONE uses. I could have named it `ASSuperCoolMenu`, but it sucks.
A `Carioca` is someone who lives in Rio de Janeiro. I lived there for two months, and this idea was born while I was there.

* * *

## Contact

- [twitter](https://twitter.com/mmommommomo)

### Creator

- [Arnaud Schloune](https://github.com/arn00s)

## License

CariocaMenu is released under the MIT license. See LICENSE for details.
