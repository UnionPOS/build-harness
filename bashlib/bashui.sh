#!/usr/bin/env bash
# shellcheck disable=SC1090

LIBDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=./array.sh
source "${LIBDIR}/array.sh"
# shellcheck source=./assert.sh
source "${LIBDIR}/assert.sh"
# shellcheck source=./banner.sh
source "${LIBDIR}/banner.sh"
# shellcheck source=./echos.sh
source "${LIBDIR}/echos.sh"
# shellcheck source=./file.sh
source "${LIBDIR}/file.sh"
# shellcheck source=./format.sh
source "${LIBDIR}/format.sh"
# shellcheck source=./functions.sh
source "${LIBDIR}/functions.sh"
# shellcheck source=./guard.sh
source "${LIBDIR}/guard.sh"
# shellcheck source=./iterm.sh
source "${LIBDIR}/iterm.sh"
# shellcheck source=./log.sh
source "${LIBDIR}/log.sh"
# shellcheck source=./os.sh
source "${LIBDIR}/os.sh"
# shellcheck source=./requirers.sh
source "${LIBDIR}/requirers.sh"
# shellcheck source=./servicemap.sh
source "${LIBDIR}/servicemap.sh"
# shellcheck source=./string.sh
source "${LIBDIR}/string.sh"
# shellcheck source=./validate.sh
source "${LIBDIR}/validate.sh"
# shellcheck source=./validate_ip.sh
source "${LIBDIR}/validate_ip.sh"
