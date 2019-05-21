#!/bin/bash

! getopt --test > /dev/null 
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
fi

OPTIONS=g:yp
LONGOPTS=gapic-generator:gapic-yaml,proto-annotation

! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    exit 2
fi

eval set -- "$PARSED"

GAPIC_GENERATOR_DIR=$GAPICGENERATOR
gapic_yaml=0
proto_annotation=0


while true; do
	case "$1" in
		-g|--gapic-generator)
      GAPIC_GENERATOR_DIR="$2"
      shift 2
  		;;
  	-y|--gapic-yaml)
			gapic_yaml=1
			shift
			;;
		-p|--proto-annotation)
      proto_annotation=1
      shift
      ;;
    --)
			shift
			break
			;;
		*)
			echo "Bad format."
	esac
done

langs=()
all_langs=("csharp" "java" "nodejs" "python" "php" "ruby" "go")

if [[ $# -eq 0 ]]; then
	langs=( "${all_langs[@]}" )
fi

for lang in "$@"
do
	case $lang in
		all)
			langs=( "${all_langs[@]}" )
			break
			;;
		csharp|go|java|nodejs|php|python|ruby)
			langs+=($lang)
			shift
			;;
	esac
done

from_dir_gapic_prefix="/tmp/com.google.api.codegen.gapic_testdata/"
from_dir_proto_prefix="/tmp/com.google.api.codegen.protoannotations_testdata/"
to_dir_gapic_prefix="${GAPIC_GENERATOR_DIR}/src/test/java/com/google/api/codegen/gapic/testdata/"
to_dir_proto_prefix="${GAPIC_GENERATOR_DIR}/src/test/java/com/google/api/codegen/protoannotations/testdata/"

from_dir=""
to_dir=""

set_from_to_dir(){
	if [[ "$2" -eq 0 ]]; then
		from_dir="${from_dir_gapic_prefix}${1}_library.baseline"
		if [[ "$1" = "python" ]] ; then
			to_dir="${to_dir_gapic_prefix}py/${1}_library.baseline"
		else
			to_dir="${to_dir_gapic_prefix}${1}/"
		fi
	else
		from_dir="${from_dir_proto_prefix}${1}_library.baseline"
		to_dir="${to_dir_proto_prefix}${1}_library.baseline"
	fi
}

for lang in "${langs[@]}"
do
	if [[ $gapic_yaml -eq 1 ]]; then
		set_from_to_dir $lang $gapic_yaml
		cp "${from_dir}" "${to_dir}"
		echo "${lang} gapic copied."
	fi
	if [[ $proto_annotation -eq 1 ]]; then
		set_from_to_dir $lang $(( 1 - $proto_annotation ))
		cp "${from_dir}" "${to_dir}"
		echo "${lang} protoannotations copied."
	fi
done

echo "Done."
