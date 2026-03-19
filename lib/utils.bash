#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for oxfmt.
GH_REPO="https://github.com/oxc-project/oxc"
TOOL_NAME="oxfmt"
TOOL_TEST="oxfmt --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if oxfmt is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# TODO: Adapt this. By default we simply list the tag names from GitHub releases.
	# Change this function if oxfmt has other means of determining installable versions.
	list_github_tags
}

# download_release() {
# 	local version filename url
# 	version="$1"
# 	filename="$2"

# 	url="$GH_REPO/archive/v${version}.tar.gz"

# 	echo "* Downloading $TOOL_NAME release $version..."
# 	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
# }

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp "${ASDF_DOWNLOAD_PATH}/$(construct_filename)" "$install_path/oxfmt"
		chmod +x "$install_path/oxfmt"

		# TODO: Assert oxfmt executable exists.
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}


github_macos_version() {
  local version
  version="$1"
  local major minor patch
  IFS='.' read -r -a array <<< "$version"
  major=${array[0]}
  minor=${array[1]}
  patch=${array[2]}

  if (( major >= 3 || (major == 2 && minor >= 13) )) ; then
    return
  fi

  return 1
}

construct_filename() {
	uname_s="$(uname -s)"
	uname_m="$(uname -m)"

	case "$uname_s" in
	  Darwin) os="apple-darwin" ;;
	  Linux) os="unknown-linux-gnu" ;;
	  *) fail "OS not supported: $uname_s" ;;
	esac

	case "$uname_m" in
	  x86_64) arch="x86_64" ;;
	  aarch64) arch="aarch64" ;;
	  armv8l) arch="arm64" ;;
	  arm64) arch="aarch64" ;;
	  *) fail "Architecture not supported: $uname_m" ;;
	esac

	echo "oxfmt-${arch}-${os}"
}

download_release() {
  local version filename uname_s uname_m os arch url actualfilename
  version="$1"
  filename="$2"

  actualfilename="$(construct_filename)"
  tag="apps_v${version}"

  # https://github.com/oxc-project/oxc/releases/download/apps_v1.56.0/oxfmt-aarch64-apple-darwin.tar.gz
  # https://github.com/oxc-project/oxc/releases/download/apps_v1.56.0/oxfmt-arm64-apple-darwin.tar.gz
  url="$GH_REPO/releases/download/${tag}/${actualfilename}.tar.gz"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

# install_version() {
#   local install_type="$1"
#   local version="$2"
#   local install_path="${3%/bin}/bin"

#   if [ "$install_type" != "version" ]; then
#     fail "asdf-$TOOL_NAME supports release installs only"
#   fi

#   (
#     mkdir -p "$install_path"
#     cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

#     # Asert hadolint executable exists.
#     local tool_cmd
#     tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
#     test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

#     echo "$TOOL_NAME $version installation was successful!"
#   ) || (
#     rm -rf "$install_path"
#     fail "An error ocurred while installing $TOOL_NAME $version."
#   )
# }
