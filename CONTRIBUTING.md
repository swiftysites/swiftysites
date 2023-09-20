# Contributing to SwiftySites

## Generate DocC

Use the following command:

```sh
swift package --allow-writing-to-directory .build generate-documentation --target SwiftySites --disable-indexing --transform-for-static-hosting --hosting-base-path SwiftySites.doccarchive

swift package --allow-writing-to-directory .build generate-documentation  --target GFMarkdown --disable-indexing --transform-for-static-hosting --hosting-base-path GFMarkdown.doccarchive

cp -rp .build/plugins/Swift-DocC/outputs/SwiftySites.doccarchive $STATIC_WEBSITE_ROOT
cp -rp .build/plugins/Swift-DocC/outputs/GFMarkdown.doccarchive $STATIC_WEBSITE_ROOT
```

On your website make sure to link to `/docc/SwiftySites.doccarchive/documentation/root`.
