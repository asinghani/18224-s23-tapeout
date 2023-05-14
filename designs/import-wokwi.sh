# script for importing a TinyTapeout Wokwi repo from TT02
mkdir $1 && \
    cd $1 &&
    cp ../../templates/tt02-wokwi-template/LICENSE . && \
    cp ../../templates/tt02-wokwi-template/README.md . && \
    cat ../../templates/tt02-wokwi-template/info.yaml | sed 's/WID/'$2'/g' > info.yaml && \
    cp -r ../../templates/tt02-wokwi-template/src src && \
    curl https://wokwi.com/api/projects/$2/verilog > src/wokwi.v && \
    vim README.md

