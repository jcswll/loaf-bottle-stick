Loaf Bottle Stick is an iOS grocery list app whose goal is to make it as fast as possible to do the most common actions: adding an item to your shopping trip list and crossing an item off when you're at the store.

This is a work in progress. The model layer is basically complete, and written in Swift. There are two fundamental datatypes: `Merch` and `Purchase`, which respectively represent items that have been used in the past, and items that are currently on a shopping trip list. These two conform to a `MarketItem` protocol, which allows the container `MarketList` type to generically hold either `Merch` or `Purchase`s. The requirements of `MarketItem` are functionality that lets the `MarketList` interact easily with its contained items: searching and sorting.

At the top of the model hierarchy is a `Market`, which represents a store in the real world. It contains two `MarketList`s, the "Inventory" of `Merch` and the "Trip" of `Purchase`s.

There is also a parallel serialization system, written in Swift, with a `MarketRepository` at the top and data/factory objects representing the models for encoding and decoding. A pair of Swift protocols, `Encoder` and `Decoder`, cover some of Cocoa's `NSCoder` functionality, allowing slightly more explicit typing for convenience. `NSKeyedArchiver` and `...Unarchiver` adopt these protocols so they can be leveraged until/unless another solution is necessary.

The architecture is roughly according to VIPER, although the Presenter and Interactor for each component are rolled into one "Presentation" object, closer to MVVM's View Model. But there will be an explicit Routing/Navigation layer.

The various `Presentation`s expose fields from their associated model, transforming them if necessary, and accept input. They follow the hierarchy of the model layer, and are linked together for change notifications and input events via simple closures.

As this is both a portfolio and learning project, the UI/view controller layer will be written in Objective-C, to demonstrate ObjC-Swift interop.

Tests have been written for all implemented functionality.
