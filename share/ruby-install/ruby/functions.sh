#!/usr/bin/env bash

RUBY_ARCHIVE="ruby-$RUBY_VERSION.tar.bz2"
RUBY_SRC_DIR="ruby-$RUBY_VERSION"
RUBY_VERSION_FAMILY="${RUBY_VERSION:0:3}"
RUBY_MIRROR="${RUBY_MIRROR:-http://cache.ruby-lang.org/pub/ruby}"
RUBY_URL="${RUBY_URL:-$RUBY_MIRROR/$RUBY_VERSION_FAMILY/$RUBY_ARCHIVE}"

#
# Setup Ruby binary installation environment variables.
#
function setup_ruby_bin()
{
	if [[ -n $DISTRO && -n $DISTRO_VERSION && -n $ARCHITECTURE ]]; then
		RUBY_BIN_PATH="$DISTRO/$DISTRO_VERSION/$ARCHITECTURE"
		RUBY_URL="http://rvm.io/binaries/$RUBY_BIN_PATH/$RUBY_ARCHIVE"
		RUBY_MD5=$(fetch "ruby/md5/$RUBY_BIN_PATH/md5" "$RUBY_ARCHIVE")
		RUBY_ARCHIVE="${RUBY_ARCHIVE%%-*}-bin-${RUBY_ARCHIVE##*-}"
	else
		return 1
	fi
}

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

#
# Installs Ruby binary into $INSTALL_DIR.
#
function install_ruby_bin()
{
	log "Installing ruby $RUBY_VERSION ..."
	mv "$SRC_DIR/$RUBY_SRC_DIR" "$INSTALL_DIR"
}

#
# Installs Ruby into $INSTALL_DIR.
#
function install_ruby()
{
	log "Installing ruby $RUBY_VERSION ..."
	make install
}
