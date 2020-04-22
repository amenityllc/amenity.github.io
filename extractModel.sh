#!/bin/sh
set -e

BASE_MODEL_DIR=$1
BASE_DIR="${AMENITY_PATH:-/data/VSA_Structure}"
CUSTOM_DATA_FOLDER="$BASE_DIR/custom_data"
echo "Searching for a custom model in ${BASE_MODEL_DIR}"
if [ -d "$BASE_MODEL_DIR"  ]
then
   echo "Model mount was found, searching for model bundle."
   ls "$BASE_MODEL_DIR"
   zipFile=$(find "${BASE_MODEL_DIR}" -name \*.zip |head -n 1)
    if [ -z "$zipFile" ]
    then
        echo "Model \$zipFile was not found."
    else
        echo "Model was found in $zipFile"
        rm -rf "${CUSTOM_DATA_FOLDER}" &&  mkdir -p "${CUSTOM_DATA_FOLDER}"
        unzip -o "${zipFile}" '*_Files/**'  -d "${CUSTOM_DATA_FOLDER}"
        mv  "${CUSTOM_DATA_FOLDER}"/*_Files/** "$CUSTOM_DATA_FOLDER"/ &&  rm  -r "$CUSTOM_DATA_FOLDER"/*_Files
        mv  "${CUSTOM_DATA_FOLDER}"/*_SAEventThresholds.txt "$CUSTOM_DATA_FOLDER"/SAEventThresholds.txt
        mv  "${CUSTOM_DATA_FOLDER}"/*_SentimentLexiconRuleSet.txt "${CUSTOM_DATA_FOLDER}"/SentimentLexiconRuleSet.txt
    fi
else
  echo "The model folder was not found!(${BASE_MODEL_DIR})"
fi
