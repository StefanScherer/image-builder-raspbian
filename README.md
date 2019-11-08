# image-builder-raspbian


Build and test Raspberry Pi SD card image

Dependecies:

  * vagrant

  * VirtualBox

Build:

```
run vagrant destroy --force && vagrant up
```



* GitHub
  * [x] Use [RPi-Distro/pi-gen](https://github.com/RPi-Distro/pi-gen) for build
  * [x] Add software
    * [x] Docker
    * [x] cloud-init
  * [x] Provide releases
* CircleCI (removed by kraeml)
  * [] Build SD card image
  * [] Test SD card image
  * [] Provide build artifacts

CircleCI not working yet. Because you have to use ubuntu 18.04 or better 19.04

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
