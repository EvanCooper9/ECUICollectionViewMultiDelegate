# ECUICollectionViewMultiDelegate

Adds the ability for a collection view to have multiple delegates.

## Installation
### Swift Package Manager

```swift
.package(url: "https://github.com/EvanCooper9/ECUICollectionViewMultiDelegate", from: "0.1.0")
```

## Usage

### Initial setup

1. Create an instance of `ECUICollectionViewMultiDelegate`
2. Set your collection view's delegate to that instance
3. Add and remove as many delegates to your `ECUICollectionViewMultiDelegate` instance through `add` and `remove` methods

### Delegate methods that return values
Some `UICollectionViewDelegate` methods require a return value (i.e. `collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool`). When multiple delegates are involved, it's hard to decide which value to take. `ECUICollectionViewMultiDelegate` will attempt to reduce all of the values returned by all the delegates, via it's `reductionDelegate` property. 

1. Implement `ECReductionDelegate`
2. Assign the `reductionDelegate` property of your `ECUICollectionViewMultiDelegate` instance and decide which value to return

> Note: If `reductionDelegate` is `nil`, the value returned will be from the last added delegate _that responds to the current method_. If no delegate responds to the current method, the default `UICollectionViewDelegate` value will be returned, as if no delegate was ever assigned.
