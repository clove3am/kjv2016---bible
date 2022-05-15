#!/bin/bash

# Dependencies: https://github.com/ericchiang/pup
#               html2markdown
#               java
#               yettoyes2.jar

# https://kjv2016.textusreceptusbibles.com

USER_AGENT='Mozilla/5.0 (X11; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0'

URL='https://kjv2016.textusreceptusbibles.com/Bible/40/1'
NAME='kjv2016'


# --> Download Bible
install -dv 'processing'
pushd 'processing'
#for NUM in {0001..1189}; do
for NUM in {0001..0260}; do
  echo -n "Downloading: ${URL}"
  HTML="$(curl -sA "${USER_AGENT}" "${URL}")" || exit 1
  BOOK="$(awk -F'/' '{print $5}' <<<"${URL}")"
  TEXT="$(pup 'tbody' <<<"${HTML}" | sed "/class=\"ref\">/a $BOOK")" || exit 1
  cat <<< "${TEXT}" >> "${NAME}.html"
  URL="https://kjv2016.textusreceptusbibles.com$(pup '.navnext attr{href}' <<<"${HTML}")" || exit 1
  echo '   DONE'
done


# --> Process Bible
html2markdown -b0 "${NAME}.html" > "${NAME}.txt"
sed -i 's/[[:blank:]]*$//' "${NAME}.txt"  # Remove trailing whitespace
sed -i 's/  |  /\t/;s/ /\t/;s/:/\t/' "${NAME}.txt"  # Add tabs
sed -i -e 's/^/verse\t/' "${NAME}.txt"  # Add "verse" string
sed -i 's/  / /g' "${NAME}.txt"  # Remove double spaces
popd


# --> Make Quick Bible files
install -dv 'quick-bible'
cp "processing/${NAME}.txt" "quick-bible/en-${NAME}--1.yet"
pushd 'quick-bible'
# NOTE: Prepend file info
java -jar yettoyes2.jar "en-${NAME}--1.yet"
popd


# --> Make tsv file for command line bible
install -dv 'terminal-program'
pushd 'terminal-program'
grep -Irl 'KJV' . | xargs sed -i 's/KJV/kjv2016/g'
grep -Irl 'kjv' . | xargs sed -i 's/kjv/kjv2016/g'
find . -name "kjv*" -exec rename -v 's/kjv/kjv2016/' {} ";"
cp "../quick-bible/en-${NAME}--1.yet" "${NAME}.tsv"
sed -i 's/^verse\t40/Matthew\tMat\t40/' "${NAME}.tsv"
sed -i 's/^verse\t41/Mark\tMark\t41/' "${NAME}.tsv"
sed -i 's/^verse\t42/Luke\tLuke\t42/' "${NAME}.tsv"
sed -i 's/^verse\t43/John\tJohn\t43/' "${NAME}.tsv"
sed -i 's/^verse\t44/The Acts\tActs\t44/' "${NAME}.tsv"
sed -i 's/^verse\t45/Romans\tRom\t45/' "${NAME}.tsv"
sed -i 's/^verse\t46/1 Corinthians\t1Cor\t46/' "${NAME}.tsv"
sed -i 's/^verse\t47/2 Corinthians\t2Cor\t47/' "${NAME}.tsv"
sed -i 's/^verse\t48/Galatians\tGal\t48/' "${NAME}.tsv"
sed -i 's/^verse\t49/Ephesians\tEph\t49/' "${NAME}.tsv"
sed -i 's/^verse\t50/Philippians\tPhi\t50/' "${NAME}.tsv"
sed -i 's/^verse\t51/Colossians\tCol\t51/' "${NAME}.tsv"
sed -i 's/^verse\t52/1 Thessalonians\t1Th\t52/' "${NAME}.tsv"
sed -i 's/^verse\t53/2 Thessalonians\t2Th\t53/' "${NAME}.tsv"
sed -i 's/^verse\t54/1 Timothy\t1Tim\t54/' "${NAME}.tsv"
sed -i 's/^verse\t55/2 Timothy\t2Tim\t55/' "${NAME}.tsv"
sed -i 's/^verse\t56/Titus\tTitus\t56/' "${NAME}.tsv"
sed -i 's/^verse\t57/Philemon\tPhmn\t57/' "${NAME}.tsv"
sed -i 's/^verse\t58/Hebrews\tHeb\t58/' "${NAME}.tsv"
sed -i 's/^verse\t59/James\tJas\t59/' "${NAME}.tsv"
sed -i 's/^verse\t60/1 Peter\t1Pet\t60/' "${NAME}.tsv"
sed -i 's/^verse\t61/2 Peter\t2Pet\t61/' "${NAME}.tsv"
sed -i 's/^verse\t62/1 John\t1Jn\t62/' "${NAME}.tsv"
sed -i 's/^verse\t63/2 John\t2Jn\t63/' "${NAME}.tsv"
sed -i 's/^verse\t64/3 John\t3Jn\t64/' "${NAME}.tsv"
sed -i 's/^verse\t65/Jude\tJude\t65/' "${NAME}.tsv"
sed -i 's/^verse\t66/Revelation\tRev\t66/' "${NAME}.tsv"
sed -i '1,35d' "${NAME}.tsv"
make
./"${NAME}" 2 pet 3:9 | cat
popd


# --> Make vpl file
install -dv 'vpl'
pushd 'vpl'
cp "../terminal-program/${NAME}.tsv" "${NAME}.vpl"
sed -i 's/\tMat\t40\t/ /' "${NAME}.vpl"
sed -i 's/\tMark\t41\t/ /' "${NAME}.vpl"
sed -i 's/\tLuke\t42\t/ /' "${NAME}.vpl"
sed -i 's/\tJohn\t43\t/ /' "${NAME}.vpl"
sed -i 's/\tActs\t44\t/ /' "${NAME}.vpl"
sed -i 's/\tRom\t45\t/ /' "${NAME}.vpl"
sed -i 's/\t1Cor\t46\t/ /' "${NAME}.vpl"
sed -i 's/\t2Cor\t47\t/ /' "${NAME}.vpl"
sed -i 's/\tGal\t48\t/ /' "${NAME}.vpl"
sed -i 's/\tEph\t49\t/ /' "${NAME}.vpl"
sed -i 's/\tPhi\t50\t/ /' "${NAME}.vpl"
sed -i 's/\tCol\t51\t/ /' "${NAME}.vpl"
sed -i 's/\t1Th\t52\t/ /' "${NAME}.vpl"
sed -i 's/\t2Th\t53\t/ /' "${NAME}.vpl"
sed -i 's/\t1Tim\t54\t/ /' "${NAME}.vpl"
sed -i 's/\t2Tim\t55\t/ /' "${NAME}.vpl"
sed -i 's/\tTitus\t56\t/ /' "${NAME}.vpl"
sed -i 's/\tPhmn\t57\t/ /' "${NAME}.vpl"
sed -i 's/\tHeb\t58\t/ /' "${NAME}.vpl"
sed -i 's/\tJas\t59\t/ /' "${NAME}.vpl"
sed -i 's/\t1Pet\t60\t/ /' "${NAME}.vpl"
sed -i 's/\t2Pet\t61\t/ /' "${NAME}.vpl"
sed -i 's/\t1Jn\t62\t/ /' "${NAME}.vpl"
sed -i 's/\t2Jn\t63\t/ /' "${NAME}.vpl"
sed -i 's/\t3Jn\t64\t/ /' "${NAME}.vpl"
sed -i 's/\tJude\t65\t/ /' "${NAME}.vpl"
sed -i 's/\tRev\t66\t/ /' "${NAME}.vpl"

sed -i 's/\t/:/' "${NAME}.vpl"
sed -i 's/\t/ /' "${NAME}.vpl"
popd
