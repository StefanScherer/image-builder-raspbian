#!/bin/bash -e

echo "$CIRCLE_TAG"

if [ "$CIRCLE_TAG" != "" ]; then
  go get github.com/tcnksm/ghr
  mkdir dist
  cp pi-gen/deploy/*.zip dist
  pushd dist
  ZIP_FILE=$(ls -1 *-hypriotos-lite.zip | tail -1)
  sha256sum "${ZIP_FILE}" > "${ZIP_FILE}.sha256"
  popd
  ghr --username ${CIRCLE_PROJECT_USERNAME} --token $GITHUB_TOKEN --replace "${CIRCLE_TAG}" dist/
else
  echo "No release tag detected. Skip deployment."
fi
