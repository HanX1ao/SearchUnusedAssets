# SearchUnusedAssets

帮助你查找工程中未被使用的 SwiftGen 生成的静态资源，及时清理。

使用方法：
将本工程 clone 下来至你的工程根目录或根目录下的子目录，以下示例是将本工程放到 Desktop/Demo/Tools 中

- 将 directoryPath 修改为你自己的工程路径，如
```swift
let directoryPath = "./Demo"
```

- 将 filePath 修改为你工程中的 SwiftGen 生成的 swift 文件，如
```swift
let filePath = "./Demo/Assets/Sources/Generated/Assets.generated.swift"
```

然后终端运行脚本即可

```shell
swift run --package-path ./Tools/SearchUnusedAssets
```
