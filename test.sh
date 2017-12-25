#!/bin/bash -e
curl -L -o kernel-qemu-4.4.34-jessie https://github.com/dhruvvyas90/qemu-rpi-kernel/blob/master/kernel-qemu-4.4.34-jessie?raw=true

sudo apt-get update && \
    DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
    binfmt-support \
    qemu \
    qemu-user-static \
    expect \
    --no-install-recommends
    
    
export IMG_DATE=${IMG_DATE:-"$(date -u +%Y-%m-%d)"}
export IMG_FILE=${IMG_DATE}-hypriotos-lite.img
export IMG_FILE=hypriotos-rpi-v1.7.1.img
export IMG_FILE=hypriotos-rpi-v1.5.0.img

if [ ! -f "$IMG_FILE" ]; then
  echo "Unzip image"
  unzip "pi-gen/deploy/image_${IMG_DATE}-hypriotos-lite.zip"
fi

PARTED_OUT=$(parted -s "${IMG_FILE}" unit b print)
ROOT_OFFSET=$(echo "$PARTED_OUT" | grep -e '^ 2'| xargs echo -n \
| cut -d" " -f 2 | tr -d B)

echo "ROOT_OFFSET: $ROOT_OFFSET"
sudo mkdir -p /mnt/hypriotos
sudo mount -v -o "offset=${ROOT_OFFSET}" -t ext4 "${IMG_FILE}" /mnt/hypriotos
sudo sed -i 's/mmcblk0p/sda/g' /mnt/hypriotos/etc/fstab 
sudo sed -i 's/PARTUUID.*-0/\/dev\/sda/' /mnt/hypriotos/etc/fstab
sudo rm -f /mnt/hypriotos/etc/ld.so.preload
sudo umount /mnt/hypriotos

pushd test
bundle install
popd

echo "Booting image"
qemu-system-arm -kernel kernel-qemu-4.4.34-jessie -cpu arm1176 -m 256 -M versatilepb -serial stdio -append "root=/dev/sda2 rootfstype=ext4 rw" -hda "${IMG_FILE}" -redir tcp:5022::22 -no-reboot &

echo "Waiting for SSH port"
set +e
maxConnectionAttempts=20
sleepSeconds=20
index=1

testssh() {
  expect <<- EOF
    spawn ssh -p 5022 -o StrictHostKeyChecking=no pirate@localhost "cat /etc/os-release"
    expect "assword:"
    send "hypriot\r"
    expect "raspbian"
    interact
EOF
}

while (( $index <= $maxConnectionAttempts ))
do
  testssh
  case $? in
    (0) echo "${index}> Success"; break ;;
    (*) echo "${index} of ${maxConnectionAttempts}> SSH server not ready yet, waiting ${sleepSeconds} seconds..." ;;
  esac
  sleep $sleepSeconds
  ((index+=1))
done
set -e

pushd test
BOARD=localhost PORT=5022 bin/rspec
popd

echo "Done!"
