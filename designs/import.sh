# script for importing a TinyTapeout-format repo into our standard format
cp -r $2 $1 && cd $1 && cp ../.lastupdated . ; rm -r .github .gitignore ; rm configure.py ; vim README.md && vim info.yaml && ls -la && ls -la src;
grep "Apache License" LICENSE > /dev/null && printf "$(tty -s && tput setaf 76)++ Valid License$(tty -s && tput sgr0)" || printf "$(tty -s && tput setaf 1)Invalid License$(tty -s && tput sgr0)"
