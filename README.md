# image-builder-raspbian

[![CircleCI](https://circleci.com/gh/StefanScherer/image-builder-raspbian/tree/master.svg?style=svg)](https://circleci.com/gh/StefanScherer/image-builder-raspbian/tree/master)

Build and test Raspberry Pi SD card image in the cloud

- GitHub
  - [x] Use [RPi-Distro/pi-gen](https://github.com/RPi-Distro/pi-gen) for build
  - [x] Add software
    - [x] Docker
    - [x] cloud-init
  - [ ] Provide releases
- CircleCI
  - [x] Build SD card image
  - [ ] Test SD card image
  - [x] Provide build artifacts

## Testing the image

### Check Config

Run Docker `check-config.sh` to see kernel settings:

```
ssh pirate@black-pearl.local
sudo modprobe configs
curl -L https://raw.githubusercontent.com/moby/moby/master/contrib/check-config.sh | sh
```

### Serverspec tests

Boot a Raspberry Pi. From your notebook run

```
cd test
bundle install
BOARD=black-pearl.local bin/rspec
```
