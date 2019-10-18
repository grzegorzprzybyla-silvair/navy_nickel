import UIKit

var str = "Hello, playground"

var dict = ["test": "alfa", "test2": "alfa", "test3": "alfa1"]

for key in dict.filter({ print("ziomek"); return $0.value == "alfa" }).keys {
    print(key)
}

