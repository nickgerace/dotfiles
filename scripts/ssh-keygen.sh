#!/usr/bin/env bash
ssh-keygen \
	-N '' \
	-C "nickgerace-$(date -u +%FT%TZ)" \
	-t rsa \
	-b 4096 \
	-a 100
