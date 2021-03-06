#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

. /opt/bitnami/scripts/libconsul.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh

# Load Consul env. variables
eval "$(consul_env)"

EXEC="${CONSUL_BASE_DIR}/bin/consul"
flags=("agent" "-config-dir" "${CONSUL_CONF_DIR}" "-log-file" "${CONSUL_LOG_FILE}")

if [[ "${CONSUL_AGENT_MODE}" = "server" ]]; then
    flags+=("-server")
fi

info "** Starting Consul **"
if am_i_root; then
    exec gosu "${CONSUL_SYSTEM_USER}" "${EXEC}" "${flags[@]}"
else
    exec "${EXEC}" "${flags[@]}"
fi
