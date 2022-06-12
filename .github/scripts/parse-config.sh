#! /bin/bash

input="../release/config.yml"

main()
{
    scriptdir="$(cd "$(dirname "$0")" && pwd)"
    pushd "$scriptdir" &> /dev/null || return

    job

    popd &> /dev/null || return
}

job()
{
    version="$(niet .config.version "$input")"
    echo "release_version=$version" >> "$GITHUB_ENV"
    echo "release_name=$(niet .config.name "$input")" >> "$GITHUB_ENV"
    echo "release_changelog=$(niet .config.changelog "$input")" >> "$GITHUB_ENV"
    echo "release_isdraft=$(niet .config.isdraft "$input")" >> "$GITHUB_ENV"
    echo "release_isprerelease=$(niet .config.isprerelease "$input")" >> "$GITHUB_ENV"

    if [ "$version" == "0.0.0" ] || git rev-parse "$version" > /dev/null 2>&1;
    then
        echo "release_exists=true" >> "$GITHUB_ENV"
    else
        echo "release_exists=false" >> "$GITHUB_ENV"
    fi
}

exit_error()
{
    popd &> /dev/null || exit 1
    exit 1
}

main
exit 0
