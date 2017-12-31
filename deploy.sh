#!/bin/bash -e

export TAG=$(git describe --exact-match "$CIRCLE_SHA1" 2>/dev/null)
if [ "${CIRCLE_BRANCH}" == "master" -a -n "${TAG}" ]; then
  go get github.com/tcnksm/ghr
  mkdir dist
  cp pi-gen/deploy/*.zip dist
  pushd dist
  ZIP_FILE=$(ls -1 *-hypriotos-lite.zip | tail -1)
  sha256sum "${ZIP_FILE}" > "${ZIP_FILE}.sha256"
  popd
  ghr --username StefanScherer --token $GITHUB_TOKEN --replace "${TAG}" dist/
else
  echo "No release tag detected. Skip deployment."
fi
