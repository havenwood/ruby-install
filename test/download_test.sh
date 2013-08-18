. ./test/helper.sh

URL="https://raw.github.com/postmodern/ruby-install/master/README.md"
OUTPUT="./test/download.txt"

test_download()
{
	download "$URL" "$OUTPUT" 2>/dev/null

	assertTrue "did not download the file" '[[ -f "$OUTPUT" ]]'
}

test_download_with_a_directory()
{
	local dir="test/subdir"
	mkdir -p "$dir"

	download "$URL" "$dir" 2>/dev/null

	assertTrue "did not download the file to the directory" \
	           '[[ -f "$dir/README.md" ]]'

	rm -r "$dir"
}

test_download_using_wget()
{
	command -v wget >/dev/null || return

	DOWNLOADER="wget" download "$URL" "$OUTPUT" 2>/dev/null

	assertTrue "did not download the file" '[[ -f "$OUTPUT" ]]'
}

test_download_using_curl()
{
	command -v curl >/dev/null || return

	DOWNLOADER="curl" download "$URL" "$OUTPUT" 2>/dev/null

	assertTrue "did not download the file" '[[ -f "$OUTPUT" ]]'
}

tearDown()
{
	rm -f "$OUTPUT"
}

SHUNIT_PARENT=$0 . $SHUNIT2
