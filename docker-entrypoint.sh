#!/bin/bash
set -e

if [[ "$1" == "digibyte-cli" || "$1" == "digibyte-tx" || "$1" == "digibyted" || "$1" == "test_digibyte" ]]; then
	mkdir -p "$DIGIBYTE_DATA"

	if [[ ! -s "$DIGIBYTE_DATA/digibyte.conf" ]]; then
		cat <<-EOF > "$DIGIBYTE_DATA/digibyte.conf"
		printtoconsole=1
                regtest=1
		rpcallowip=::/0
		rpcpassword=${DIGIBYTE_RPC_PASSWORD:-password}
		rpcuser=${DIGIBYTE_RPC_USER:-digibyte}
		EOF
		chown digibyte:digibyte "$DIGIBYTE_DATA/digibyte.conf"
	fi

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R digibyte "$DIGIBYTE_DATA"
	ln -sfn "$DIGIBYTE_DATA" /home/digibyte/.digibyte
	chown -h digibyte:digibyte /home/digibyte/.digibyte

	exec gosu digibyte "$@"
fi

exec "$@"
