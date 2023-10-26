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

如果工程较大，等待的时间可能比较长，检测过程中会输出

```shell
Building for debugging...
[3/3] Linking SearchUnusedAssets
Build complete! (3.64s)
assets icon1 unused // 检测某个资源未使用
assets icon2 unused // 检测某个资源未使用
🚀 check complete!  // 代表检测完成
```
