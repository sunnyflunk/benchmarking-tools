#!/bin/true

benchmarkSources=("linux-kernel")
benchmarkSetup=("cp ${BT_CACHE_DIR}/linux-4.0.tar.xz ."
                "xz -d linux-4.0.tar.xz"
                "mv linux-4.0.tar linux.tar")
