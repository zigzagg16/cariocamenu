![](docs/readme_header.jpg)

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)
[![Carthage compatible](https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/Hero.svg?style=flat)](http://cocoapods.org/pods/Hero)
![iOS 9.0+](https://img.shields.io/badge/iOS-9.0%2B-blue.svg)
![Swift 4.0+](https://img.shields.io/badge/Swift-4.0%2B-orange.svg)
[![License](https://img.shields.io/cocoapods/l/Hero.svg?style=flat)](https://github.com/arn00s/cariocamenu/blob/master/LICENSE?raw=true)
[![CocoaPods](https://img.shields.io/cocoapods/dt/CariocaMenu.svg)]()
[![Twitter URL](https://img.shields.io/twitter/url/https/github.com/arn00s/cariocamenu.svg?style=social)](https://twitter.com/intent/tweet?text=This%20menu%20is%20awesome:&url=https%3A%2F%2Fgithub.com%2Farn00s%2Fcariocamenu)

## ⚡️ Quicklook

The fastest zero-tap iOS menu

CariocaMenu is a **simple**, **elegant**, **fast** navigation menu for your **iOS** apps.

![](https://raw.githubusercontent.com/arn00s/cariocamenu/master/cariocamenu.gif)

## 🏆 Features

- [x] Accessible from a single swipe of the left/right screen edge
- [x] Accessible with a tap on the indicator
- [x] Customisable menu indicator
- [x] Menu Item supports image & emoji/text
- [x] Boomerang mode
- [x] Supports rotation (Full AutoLayout)
- [x] Supports iPhone X & the Notch !
- [x] [Complete Technical Documentation](http://arn00s.github.io/cariocamenu/)

## 📝 Requirements

- AutoLayout
- iOS 9.0+
- Swift 4.0

## 📢 Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/CariocaMenu). (Tag 'CariocaMenu')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/CariocaMenu).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.
- If you **use the control**, contact me to mention your app on this page.

## 📲 Installation

### CocoaPods
CariocaMenu is now available on [CocoaPods](http://cocoapods.org).
Simply add the following to your project Podfile, and you'll be good to go.

```ruby
use_frameworks!

pod 'CariocaMenu', '~> 2.0.1'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralised dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate CariocaMenu into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "arn00s/cariocamenu"
```

Run `carthage` to build the framework and drag the built `CariocaMenu.framework` into your Xcode project.

### Manually

If you prefer, you can integrate CariocaMenu into your project manually.

Just Drag&Drop all the files under `Sources/` into your project.

---

## 💻 Usage

### Preparing your menu controller

To create and display your menu, you'll need to create a custom **CariocaController** (UITableViewController & CariocaDataSource)

This will define your menu settings & appearance. Check **DemoMenuContentController.swift** for code sample.

### Creating your menu

For the complete code, check **MainViewController.swift**.
```swift
if let controller = self.storyboard?.instantiateViewController(withIdentifier: "DemoMenu")
    as? CariocaController {
      addChildViewController(controller)
      carioca = CariocaMenu(controller: controller,
                            hostView: self.view,
                            edges: [.right, .left],
                            delegate: self,
                            indicator: CariocaCustomIndicatorView()
                            )
      carioca.addInHostView()
}
```

### Managing rotation

To be able to manage the rotation of the menu, you'll need to forward the rotation event to your menu instance.

```swift
override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
  coordinator.animateAlongsideTransition(in: self.view, animation: nil, completion: { [weak self] _ in
    self?.carioca?.hostViewDidRotate()
  })
}
```

### Creating your custom indicator

Here's the simplest custom indicator. Feel free to check the **CariocaIndicatorConfiguration** extension for more customisation possibilities.

```swift
class CariocaCustomIndicatorView: UIView, CariocaIndicatorConfiguration {
  ///This will use the basic shape, and change the color to black.
  var color: UIColor = UIColor.black
}
```

### Boomerang

A boomerang always comes back to it's original place.
By default, the boomerang is set to `none`. It means that the menu will stay where the user let it.

The other boomerang options are :

- `horizontal` : The indicator will return always on the original edge.
- `vertical` : The indicator will return always on the original Y position. It may switch from Edge.
- `originalPosition` : The indicator will always come back to it's original position

## 👨‍💻 TODO

- Add a check for the edges at the initialisation. (Only .left & .right are allowed)
- Add UI Tests
- Add a `live tutorial` to indicate users how to get the most of this menu

## ⚠️ Known issues

Check the ([GitHub issues](https://github.com/arn00s/CariocaMenu/issues))

## 🤔 FAQ

### 😍 Why should I use `CariocaMenu`?

You're starting a new iOS app, and you want to innovate on the user experience.

### 🇧🇷 Why the name `CariocaMenu`?

I didn't want to use the same naming convention that **EVERYONE** uses. I could have named it `ASSuperCoolMenu`, but it sucks.
A `Carioca` is someone who lives in Rio de Janeiro 🇧🇷. I lived there for two months, and this idea was born while I was there.

## 🤙🏼 Contact

- [twitter](https://twitter.com/mmommommomo)

## ❤️ Contributions
This is an open source project, feel free to contribute!
- Open an [issue](https://github.com/arn00s/cariocamenu/issues/new).
- Propose your own fixes, suggestions and open a pull request with the changes.

See [all contributors](https://github.com/arn00s/cariocamenu/graphs/contributors)

###### Project generated with [SwiftPlate](https://github.com/JohnSundell/SwiftPlate)

## 📝 License

CariocaMenu is released under the MIT license. See LICENSE for details.
