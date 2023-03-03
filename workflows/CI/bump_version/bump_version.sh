#!/bin/bash

# Works with a file called VERSION in the current directory,
# the contents of which should be a semantic version number
# such as "1.2.3"

# this script will display the current version, automatically
# suggest a "minor" version update, and ask for input to use
# the suggestion, or use a newly entered value.

set -e

VERSION_FILE=$1
VERSION_DATA=$2
COMMIT_PUSH_FLAG=$3
CURRENT_VERSION="0.0.0"

suggest_version() {
  #local CURRENT_VERSION
  local CURRENT_MAJOR
  local CURRENT_MINOR
  local CURRENT_PATCH
  
  BASE_LIST=(`echo $CURRENT_VERSION | tr '.' ' '`)
  #CURRENT_MAJOR=$(echo "$CURRENT_VERSION" | cut -d. -f1)
  #CURRENT_MINOR=$(echo "$CURRENT_VERSION" | cut -d. -f2)
  #CURRENT_PATCH=$(echo "$CURRENT_VERSION" | cut -d. -f3)
  CURRENT_MAJOR=${BASE_LIST[0]}
  CURRENT_MINOR=${BASE_LIST[1]}
  CURRENT_PATCH=${BASE_LIST[2]}

  if [ "$CURRENT_PATCH" = "" ]; then
	  SUGGESTED_PATCH=0
          SUGGESTED_MINOR=$((CURRENT_MINOR + 1))
  elif [ "$CURRENT_PATCH" = "0" ]; then
	  SUGGESTED_PATCH=$((CURRENT_PATCH + 1))
     	  SUGGESTED_MINOR=$((CURRENT_MINOR + 0))
  else
	  SUGGESTED_PATCH=$((CURRENT_PATCH + 1))
          SUGGESTED_MINOR=$((CURRENT_MINOR + 0))
  fi	  

  echo "$CURRENT_MAJOR.$SUGGESTED_MINOR.$SUGGESTED_PATCH"
}

update_version() {
  NEW_VERSION=$1; shift
  
  echo "$NEW_VERSION" > $VERSION_FILE
  git add $VERSION_FILE
}

push_tags() {
  NEW_VERSION=$1; shift

  echo "Pushing new version to the origin"
  git commit -m "Bump version to ${NEW_VERSION}."
  #git tag -a -m "Tag version ${NEW_VERSION}." "v$NEW_VERSION"
  git push origin
  #git push origin --tags
}


if [ "$VERSION_FILE" != "false" ];  then
    if [ -f $VERSION_FILE ]; then
      CURRENT_VERSION=`cat ${VERSION_FILE}`
      SUGGESTED_VERSION=$(suggest_version)
      echo "Current version: $(cat ${VERSION_FILE})"
      echo "next version: $SUGGESTED_VERSION"
      
      NEW_VERSION=""
      if [ "$NEW_VERSION" = "" ]; then NEW_VERSION=$SUGGESTED_VERSION; fi
      update_version "$NEW_VERSION"
      push_tags "$NEW_VERSION"
    else
      echo "could not find the $VERSION_FILE file provided"
      exit 1
    fi
 elif [ "$VERSION_DATA" != "false" ]; then
   CURRENT_VERSION=$VERSION_DATA
   SUGGESTED_VERSION=$(suggest_version)
   echo "Current version: $CURRENT_VERSION"
   echo "next version: $SUGGESTED_VERSION"
   echo "$SUGGESTED_VERSION" > ./suggested_version.txt
   
 else
    echo "no Version info provided; Please verify inputs"
    exit 1
 fi	
