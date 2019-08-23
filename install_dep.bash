#bin/bash

set -e

download_protoc()
{
	curl -L https://github.com/protocolbuffers/protobuf/releases/download/v3.9.1/protoc-3.9.1-linux-x86_64.zip \
	  --output /tmp/protoc.zip
	mkdir $HOME/.local/protoc
	unzip /tmp/protoc.zip -d $HOME/.local/protoc > /dev/null
	echo "add this line to ~/.bashrc:"
	echo 'export PATH=$PATH:$HOME/.local/protoc/bin'
}


if [ $1 == "protoc" ] ; then 
	download_protoc
fi
