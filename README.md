# TraceItX Releases

Public binary releases for the [TraceItX](https://traceitx.com) SDK.

Source code lives in the private `scriptx-com/traceitx` repository; only
compiled binaries (iOS xcframework zips) are published here so that
anonymous `pod install` works.

## Available downloads

Each tag corresponds to a TraceItX SDK release. Release assets:

- `TraceItXKit.xcframework.zip` — SDK core (capture, envelope, transport, companion-mode reporter).
- `TraceItXReporterUI.xcframework.zip` — on-device reporter modal (opt-in subspec).

## Install

```ruby
# Podfile
pod 'TraceItX', '~> 0.1'
# Opt-in on-device reporter UI:
pod 'TraceItX/ReporterUI', '~> 0.1'
```

## Why a separate public repo?

CocoaPods cannot attach auth headers when fetching `:http =>` sources, so
the xcframework zips must be anonymously fetchable. Hosting them here
(public) keeps the source code repo (private) closed-source.
