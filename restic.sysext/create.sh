#!/usr/bin/env bash
# vim: et ts=2 syn=bash
#
# restic extension.
#

RELOAD_SERVICES_ON_MERGE="false"

function list_available_versions() {
  list_github_releases "restic" "restic"
}
# --

function populate_sysext_root() {
  local sysextroot="$1"
  local arch="$2"
  local version="${3:1}"

  local rel_arch="$(arch_transform "x86-64" "amd64" "$arch")"
  curl --parallel --fail --silent --show-error --location \
        --remote-name "https://github.com/restic/restic/releases/download/v${version}/restic_${version}_linux_${rel_arch}.bz2"
  bzip2 -d "restic_${version}_linux_${rel_arch}.bz2"

  mkdir -p "${sysextroot}/usr/local/bin"

  cp restic_${version}_linux_${rel_arch} "${sysextroot}/usr/local/bin/restic"
  chmod 755 "${sysextroot}/usr/local/bin/restic"
}
# --
