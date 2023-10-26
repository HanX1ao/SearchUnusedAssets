import Foundation

let directoryPath = "./your project path"

var swiftFiles: [String] = []
/// 递归遍历目录并查找.swift文件
func findSwiftFiles(inDirectory path: String) {
    do {
        let directoryContents = try FileManager.default.contentsOfDirectory(atPath: path)
        
        for item in directoryContents {
            let itemPath = "\(path)/\(item)"
            
            var isDirectory: ObjCBool = false
            
            if FileManager.default.fileExists(atPath: itemPath, isDirectory: &isDirectory) {
                if isDirectory.boolValue {
                    // 如果是目录，则递归查找
                    findSwiftFiles(inDirectory: itemPath)
                } else if itemPath.hasSuffix(".swift") {
                    // 如果是.swift文件，则添加到结果列表
                    swiftFiles.append(itemPath)
                }
            }
        }
    } catch {
        print("无法读取目录内容: \(error.localizedDescription)")
    }
}

findSwiftFiles(inDirectory: directoryPath)

let filePath = "./Project/Assets/Sources/Generated/Assets.generated.swift"

let fileURL = URL(fileURLWithPath: filePath)

guard let fileContent = try? String(contentsOf: fileURL, encoding: .utf8) else {
    print("无法读取文件内容")
    exit(1)
}

/// 定义正则表达式模式
let pattern = #"enum\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\{([^}]*)\}"#

// 创建正则表达式对象
guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
    print("无效的正则表达式模式")
    exit(1)
}

/// 查找匹配项
let matches = regex.matches(
    in: fileContent,
    options: [],
    range: NSRange(location: 0, length: fileContent.utf16.count)
)

for match in matches {
//    print("\rProgress: \(objc.offset + 1 / propertyPattern.count)", terminator: "")
    let enumNameRange = match.range(at: 1)
    if let enumNameSwiftRange = Range(enumNameRange, in: fileContent) {
        let _ = fileContent[enumNameSwiftRange]

        let enumBodyRange = match.range(at: 2)
        if let enumBodySwiftRange = Range(enumBodyRange, in: fileContent) {
            let enumBody = fileContent[enumBodySwiftRange]

            let propertyPattern = #"static let\s+([a-zA-Z_][a-zA-Z0-9_]*)"#
            guard let propertyRegex = try? NSRegularExpression(
                pattern: propertyPattern,
                options: []
            ) else {
                print("无效的属性正则表达式模式")
                exit(1)
            }

            let propertyMatches = propertyRegex.matches(
                in: String(enumBody),
                options: [],
                range: NSRange(location: 0, length: enumBody.utf16.count)
            )

            for propertyMatch in propertyMatches {
                let propertyRange = propertyMatch.range(at: 1)
                if let propertySwiftRange = Range(propertyRange, in: enumBody) {
                    let propertyName = enumBody[propertySwiftRange]
                    findEnumInAllFiles(String(propertyName))
                }
            }
        }
    }
}

func findEnumInAllFiles(_ name: String) {
    let targetStaticLet = name

    // 解析单个.swift文件，查找目标 static let 的引用或调用
    func parseSwiftFile(filePath: String, targetStaticLet: String) -> Int {
        do {
            let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)

            let pattern = #"(\w?)\.\#(targetStaticLet)\b"#
            let regex = try NSRegularExpression(pattern: pattern, options: [])

            let range = NSRange(location: 0, length: fileContent.utf16.count)
            let matches = regex.matches(in: fileContent, options: [], range: range)

            return matches.count
        } catch {
            print("无法读取文件内容: \(error.localizedDescription)")
            return 0
        }
    }

    // 统计目标 static let 的引用或调用次数
    var totalCount = 0
    for file in swiftFiles {
        let count = parseSwiftFile(filePath: file, targetStaticLet: targetStaticLet)
        totalCount += count
    }

    // 打印结果
    if totalCount == 0 {
        print("assets \(targetStaticLet) unused")
    }
}

print("🚀 check complete! ")
