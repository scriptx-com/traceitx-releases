// swift-tools-version: 5.10
// SPDX-License-Identifier: Apache-2.0
// Copyright 2026 ScriptX
//
// BINARY-DISTRIBUTION Package.swift. NOT used during local development —
// `Package.swift` (the source-based manifest) is the working file. At release
// time the publishing runbook (PUBLISHING.md) renames this file to
// `Package.swift` on the `release/<version>` branch, after updating the
// `binaryVersion` constant + each `checksum:` to match the artifacts attached
// to the GitHub Release on `scriptx-com/traceitx-releases`. The xcframework
// zips are public on that repo so anonymous SwiftPM consumers can fetch them.
//
// Consumers reference the binary tag, e.g.
//
//     dependencies: [
//         .package(url: "https://github.com/scriptx-com/traceitx-releases", from: "0.1.1"),
//     ]
//
// **Update these per release — both are now automated; do not hand-edit:**
//   * binaryVersion   — the SemVer string of the release. Written by
//                       `scripts/sync-version.sh` from TraceItX.podspec.
//   * each binaryTarget's `checksum:` — written by
//                       `scripts/build-xcframework.sh` (Release builds only)
//                       from the zips it just produced.
//
// The two are written at DIFFERENT times, and that gap is the trap: a version
// bump alone (sync-version.sh, or any release-prep script that calls it)
// advances `binaryVersion` while leaving the PREVIOUS release's checksums in
// place. The manifest then looks plausible and is completely broken — SwiftPM
// rejects every fetch with "checksum of downloaded artifact does not match".
// v0.5.0 shipped into this exact state carrying 0.4.5 hashes.
//
// `scripts/verify-binary-checksums.sh` is the guard. Run it against the
// published artifacts before `pod trunk push` (PUBLISHING.md §6); it is also
// available as the `release-verify` workflow. On a feature branch that has
// bumped ahead of the release, `--allow-unpublished` is the honest answer —
// inventing placeholder checksums is not.
//
// Three binary targets ship in lockstep:
//   * TraceItXKit          — the core SDK (was published as TraceItX in 0.1.0)
//   * TraceItXProtocol     — wire-format types referenced by TraceItXKit's
//                            .swiftinterface; SwiftPM can't resolve the import
//                            unless this is a visible dependency target, even
//                            though no consumer imports it directly.
//   * TraceItXReporterUI   — optional reporter modal (opt-in via product).
import PackageDescription

let binaryVersion = "0.6.6"
let baseURL = "https://github.com/scriptx-com/traceitx-releases/releases/download/v\(binaryVersion)/"

let package = Package(
    name: "TraceItX",
    platforms: [.iOS(.v15), .tvOS(.v15)],
    products: [
        // Public product name stays `TraceItX` for source-compat with the
        // 0.1.0 manifest. It depends on both Kit + Protocol so a consumer
        // `import TraceItX` resolves the .swiftinterface symbols.
        .library(name: "TraceItX",           targets: ["TraceItXKit", "TraceItXProtocol"]),
        .library(name: "TraceItXReporterUI", targets: ["TraceItXReporterUI"]),
    ],
    targets: [
        // NOTE: the checksums below must match the zips actually attached to
        // the GitHub Release on `scriptx-com/traceitx-releases`. The local
        // `dist/` directory may be ahead of the published artifacts after a
        // rebuild, so the authoritative check hashes the *fetched* zips:
        //     scripts/verify-binary-checksums.sh
        .binaryTarget(
            name: "TraceItXKit",
            url: baseURL + "TraceItXKit.xcframework.zip",
            checksum: "abc3d2fd82ae3eb76bb57fb22203087f5507d358d4674343fdb97aa8f954ac3a"
        ),
        .binaryTarget(
            name: "TraceItXProtocol",
            url: baseURL + "TraceItXProtocol.xcframework.zip",
            checksum: "39b5f8842a2eccd3a487e95d5170bcd106f56ae3ad32e1c12e0e0592a8491299"
        ),
        .binaryTarget(
            name: "TraceItXReporterUI",
            url: baseURL + "TraceItXReporterUI.xcframework.zip",
            checksum: "bda73843bfcfc3ee6a5fc85d6e7199f8725c838e9f82662d29cc9157b80e17d2"
        ),
    ]
)
