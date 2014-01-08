#!/usr/bin/env bash

RUBY_ARCHIVE="ruby-$RUBY_VERSION.tar.bz2"
RUBY_SRC_DIR="ruby-$RUBY_VERSION"

if "$BINARY_INSTALL"; then
	BINARY_BASE_URL="http://rvm.io/binaries"
	ARCHITECTURE=$(uname -m)

	case "$PACKAGE_MANAGER" in
		apt)
			if [[ -e "/etc/lsb-release" ]]; then DISTRO="ubuntu"
			elif [[ -e "/etc/debian_release" ]]; then DISTRO="debian"
			else DISTRO=""
			fi

			DISTRO_VERSION=$(lsb_release -rs) ;;
		yum)
			if [[ -e "/etc/fedora-release" ]]; then
				DISTRO="fedora"
				DISTRO_VERSION=$(lsb_release -rs)
			elif [[ -e "/etc/redhat-release" ]]; then;
				DISTRO="centos"
				DISTRO_VERSION=$(cat /etc/redhat-release | cut -d" " -f3)
			else
				DISTRO=""
			fi ;;
		brew|port)
			DISTRO="osx"
			DISTRO_VERSION=$(sw_vers -productVersion)
			DISTRO_VERSION=${DISTRO_VERSION:0:4} ;;
		zypper)
			DISTRO="opensuse"
			DISTRO_VERSION=$(cat /etc/SuSE-release | grep VERSION)
			DISTRO_VERSION=${DISTRO_VERSION##* } ;;
		*)
			DISTRO=""
			DISTRO_VERSION="" ;;
	esac

	if [[ -n $DISTRO && -n $DISTRO_VERSION && -n $ARCHITECTURE ]]; then
		RUBY_URL="$BINARY_BASE_URL/$DISTRO/$DISTRO_VERSION/$ARCHITECTURE/$RUBY_ARCHIVE"
	else
		fail "No binaries found for your distro/architecture."
	fi
else
	RUBY_VERSION_FAMILY="${RUBY_VERSION:0:3}"
	RUBY_MIRROR="${RUBY_MIRROR:-http://cache.ruby-lang.org/pub/ruby}"
	RUBY_URL="${RUBY_URL:-$RUBY_MIRROR/$RUBY_VERSION_FAMILY/$RUBY_ARCHIVE}"
	
	#
	# Configures Ruby.
	#
	function configure_ruby()
	{
		log "Configuring ruby $RUBY_VERSION ..."

		if [[ "$PACKAGE_MANAGER" == "brew" ]]; then
			./configure --prefix="$INSTALL_DIR" \
				    --with-opt-dir="$(brew --prefix openssl):$(brew --prefix readline):$(brew --prefix libyaml):$(brew --prefix gdbm):$(brew --prefix libffi)" \
				    "${CONFIGURE_OPTS[@]}"
		else
			./configure --prefix="$INSTALL_DIR" "${CONFIGURE_OPTS[@]}"
		fi
	}

	#
	# Compiles Ruby.
	#
	function compile_ruby()
	{
		log "Compiling ruby $RUBY_VERSION ..."
		make "${MAKE_OPTS[@]}"
	}
	
fi

#
# Installs Ruby into $INSTALL_DIR
#
function install_ruby()
{
	log "Installing ruby $RUBY_VERSION ..."
	make install
}
