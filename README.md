Swizzle
=======

Method-Swizzling for Swift.


## Example

```swift
swizzleInstanceMethod(MyObject.self, "hello", "bye")

swizzleClassMethod(MyObject.self, "hello", "bye")
```

### Using custom operator

```swift
(MyObject.self, "hello") <-> "bye"  // swizzleInstanceMethod

(MyObject.self, "hello") <+> "bye"  // swizzleClassMethod
```


## Licence

[MIT](https://github.com/inamiy/Swizzle/blob/master/LICENSE)
