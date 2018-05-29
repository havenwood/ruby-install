#!/usr/bin/env bash

case "$(uname -s)" in
	# Darwin)	os_family="macos" ;; # TODO: Enable once macOS is supported in CE.
	Linux)	os_family="linux" ;;
	*)	fail "TruffleRuby Community Edition is only supported on Linux ..." ;;
esac

ruby_archive="graalvm-ce-$ruby_version-$os_family-amd64.tar.gz"
ruby_url="https://github.com/oracle/graal/releases/download/vm-$ruby_version/$ruby_archive"
ruby_dir_name="truffleruby-$ruby_version"

#
# Extract the TruffleRuby archive
#
function extract_ruby()
{
	log "Extracting $ruby_archive to $src_dir/$ruby_dir_name ..."

	extract "$src_dir/$ruby_archive" "$src_dir" || return $?
	rm -rf "$src_dir/$ruby_dir_name" || return $?
	mv "$src_dir/graalvm-$ruby_version" "$src_dir/$ruby_dir_name" || return $?
}

#
# Install TruffleRuby into $install_dir.
#
function install_ruby()
{
	log "Installing truffleruby $ruby_version ..."

	bin/gu install -c org.graalvm.ruby || return $?
	cp -R "$src_dir/$ruby_dir_name" "$install_dir" || return $?
}
