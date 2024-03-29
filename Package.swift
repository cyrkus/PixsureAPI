import PackageDescription

let package = Package(
    name: "OnYourFeet",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 5),
        .Package(url: "https://github.com/vapor/mongo-provider.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/nodes-vapor/aws.git", majorVersion: 0)
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
    ]
)

