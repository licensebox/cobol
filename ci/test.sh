#!/usr/bin/env bash
set -euo pipefail
mkdir -p build/install/lib build/install/include
cc -I"$LICENSEBOX_LIB_DIR/../include" -c src/owner.c -o build/owner.o -pthread
cc -I"$LICENSEBOX_LIB_DIR/../include" -c src/bridge.c -o build/bridge.o
cobc -free -c src/licensebox.cob -o build/licensebox.o
ar rcs build/install/lib/liblicensebox_cobol.a build/licensebox.o build/owner.o build/bridge.o
install -m644 src/licensebox.cpy build/install/include/
cobc -free -x tests/binding.cob build/licensebox.o build/owner.o build/bridge.o -L"$LICENSEBOX_LIB_DIR" -llicensebox -lpthread -o build/binding
./build/binding
cc -I"$LICENSEBOX_LIB_DIR/../include" -c tests/frame.c -o build/frame.o
cobc -free -x tests/adapter.cob build/licensebox.o build/owner.o build/bridge.o build/frame.o -L"$LICENSEBOX_LIB_DIR" -llicensebox -lpthread -o build/adapter
cobc -free -x -fstatic-call examples/status.cob -Lbuild/install/lib -llicensebox_cobol -L"$LICENSEBOX_LIB_DIR" -llicensebox -lpthread -o build/consumer
