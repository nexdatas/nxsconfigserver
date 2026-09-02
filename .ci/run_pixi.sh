#!/usr/bin/env bash

echo "install pixi"
docker exec  ndts /bin/bash -c 'curl -fsSL https://pixi.sh/install.sh | sh ; export PATH=$HOME/.pixi/bin:$PATH ; pixi shell-hook  --manifest-path .github/workflows/pixi/pixi.toml > .sh.sh ; source .sh.sh ; pixi add  --manifest-path .github/workflows/pixi/pixi.toml rattler-build '
docker exec  ndts /bin/bash -c 'pwd '
docker exec  ndts /bin/bash -c 'echo "$HOME" '

echo "run nxsconfigserver-db"
docker exec  ndts /bin/bash -c 'source .sh.sh ; pixi run  --manifest-path .github/workflows/pixi/pixi.toml rattler-build build  --recipe .github/workflows/pixi/recipe.yaml'

ERROR=$?
if [ $ERROR -ne "0" ]
then
    echo "ERROR "$ERROR
    exit 255
fi
