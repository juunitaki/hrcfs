# hrcfs
HTTP Rage Cache Filesystem

## Overview

hrcfs is a filesystem based on FUSE. hrcfs makes possible to mount HTTP dir
into a filesystem tree. hrcfs downloads only requested blocks of file using
`Range:` request header and cache it.

## Build

    make

## Usage Example

    mkdir -p /var/cache/hrcfs/metainfo
    mkdir -p /var/cache/hrcfs/data
    mkdir -p /var/cache/hrcfs/media
    ./hrcfs /var/cache/hrcfs/media \
            -o origin=http://download.blender.org/peach/bigbuckbunny_movies \
            -o cachemetadir=/var/cache/hrcfs/metainfo \
            -o cachedatadir=/var/cache/hrcfs/data

Copy 32000 bytes from BigBuckBunny_320x180.mp4:

    $ dd if=/var/cache/hrcfs/media/BigBuckBunny_320x180.mp4 of=/dev/null bs=1 count=32000
    32000+0 records in
    32000+0 records out
    32000 bytes (32 kB) copied, 1.45306 s, 22.0 kB/s

Check the real file size in cache:

    $ du -sb /var/cache/hrcfs/data/BigBuckBunny_320x180.mp4 
    131072	/var/cache/hrcfs/data/BigBuckBunny_320x180.mp4

### Use hrcfs together with Wowza Media Server

Just set a StorageDir in the app configuration to a directory mounted with hrcfs:

    <Streams>
        <StreamType>default</StreamType>
        <StorageDir>/var/cache/hrcfs/media</StorageDir>
        <Properties>
        </Properties>
    </Streams>

Note: Wowza Media Systems provides a cache plugin for on-demand content, but
this plugin clears cache after restart. hrcfs does not.

## Lazy upgrade

    fusermount -uz /var/cache/hrcfs/media
    ./hrcfs /var/cache/hrcfs/media \
            -o origin=http://download.blender.org/peach/bigbuckbunny_movies \
            -o cachemetadir=/var/cache/hrcfs/metainfo \
            -o cachedatadir=/var/cache/hrcfs/data

Do not kill existing hrcfs process. It continues to process already open files.
