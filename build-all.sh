#/bin/bash

set -e

export PATH=/opt/macports/libexec/gnubin:/opt/macports/bin:$PWD/bin:$PATH

for i in makesys transcript t3shared t3window t3widget t3key t3config t3highlight tilde; do
    rm -rf $i
    git clone --depth=1 --recursive --no-single-branch https://github.com/gphalkes/$i.git
done

LLGEN=0.5.5
curl -OL https://os.ghalkes.nl/LLnextgen/releases/LLnextgen-${LLGEN}.tgz
rm -rf LLnextgen-${LLGEN} && tar xzf LLnextgen-${LLGEN}.tgz && rm LLnextgen-${LLGEN}.tgz
( cd LLnextgen-${LLGEN} && ./configure && make && cp LLnextgen ../bin )

for p in $(ls *.patch); do
    echo "== patch found: $p"
    patch < $p
done

# build all packages: 
./t3shared/doall --skip-non-source --stop-on-error make -C src
