#!/bin/zsh
url=$(curl -s https://github.com | grep -Po 'https://.+/github-.+\.css')
css=$(curl -s $url | grep -Po '(?<=}|^)(\.octicon(-[\w-]+:before)?|@font-face){[^}]+}')
fonts=$(grep -Po '(?<=url\(").+?(?=(#.+)?"\))' <<< $css | sort -u)

for font in ${=fonts}; do
	file=${${font/-*./.}/\/assets\//}
	css=${css//$font/$file}
	curl -s ${url/\/assets\/*/$font} > $file
done

print -r $css > octicons.min.css
