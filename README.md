
example:

docker run  -d --rm --name shellbot -ti \
            -v $(pwd)/.profile:/root/.zshenv \
            -v ~/.habitctl/:/root/.habitctl/  \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v ~/Documents/hledger:/root/hledger \
            -e SHELL=/bin/zsh shellbot