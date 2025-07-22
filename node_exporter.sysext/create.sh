#!/usr/bin/env bash
# vim: et ts=2 syn=bash
#
# node_exporter extension.
#

RELOAD_SERVICES_ON_MERGE="true"

function list_available_versions() {
  list_github_releases "prometheus" "node_exporter" | sed '/rc/d'
}
# --

function populate_sysext_root() {
  local sysextroot="$1"
  local arch="$2"
  local version="${3:1}"

  local rel_arch="$(arch_transform "x86-64" "amd64" "$arch")"
  curl --parallel --fail --silent --show-error --location \
        --remote-name "https://github.com/prometheus/node_exporter/releases/download/v${version}/node_exporter-${version}.linux-${rel_arch}.tar.gz" \
        --remote-name "https://github.com/prometheus/node_exporter/raw/refs/tags/v${version}/examples/systemd/node_exporter.service" \
        --remote-name "https://github.com/prometheus/node_exporter/raw/refs/tags/v${version}/examples/systemd/node_exporter.socket"

  tar -zxf "node_exporter-${version}.linux-${rel_arch}.tar.gz"

  mkdir -p "${sysextroot}/usr/bin"
  mkdir -p "${sysextroot}/usr/lib/systemd/system"

  cp "node_exporter-${version}.linux-${rel_arch}/node_exporter" "${sysextroot}/usr/bin/"
  cp node_exporter.service node_exporter.socket "${sysextroot}/usr/lib/systemd/system/"

  sed -i \
    -e 's,/usr/sbin/node_exporter,/usr/bin/node_exporter,g' \
    -e  '/User=/d' \
    "${sysextroot}/usr/lib/systemd/system/node_exporter.service"
}
# --
