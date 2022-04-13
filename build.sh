#!/bin/sh -e
cd "$(dirname "$0")"

rm -f ./fixuid
CGO_ENABLED=0 go build -ldflags="-s -w" && echo ErrorCode $? || echo ErrorCode $?
