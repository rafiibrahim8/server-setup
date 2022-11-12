#!/bin/bash
## ###BUILD_DATE###

add_user_to_group() {
    if [ $(getent group $2) ]; then
        echo "Adding user \`$1\` to group \`$2\`"
        usermod -a -G $2 $1
    else
        echo "Group \`$2\` does not exist"
    fi
}

add_user_to_groups() {
    for group in $2; do
        add_user_to_group $1 $group
    done
}

install_packages() {
    apt update
    apt install -y ###PACKAGES###
}

install_starship() {
    curl -sS https://starship.rs/install.sh | sh -s -- -y
}

setup_nodejs() {
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    apt install -y nodejs
    npm install -g pm2
    npm install -g https://github.com/rafiibrahim8/http-server/tarball/customized
}

unzip_fs() {
    unzip -o -d / fs.zip
}

print_ssh_key_fingerprint() {
    echo "SSH key fingerprint:"
    ssh-keygen -E sha256 -lf /etc/ssh/ssh_host_ed25519_key.pub
    ssh-keygen -E md5 -lf /etc/ssh/ssh_host_ed25519_key.pub
}

setup_users() {
    adduser --disabled-password --add_extra_groups --shell /usr/bin/fish --gecos 'Ibrahim Rafi' ibra
    add_user_to_groups ibra 'adm dialout cdrom floppy sudo audio dip video plugdev netdev lxd'
    passwd -d ibra
    passwd -l ibra
    find /etc/sudoers.d ! -name 'README' -type f -exec rm -f {} +
    echo "ibra ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/10-ibra
    sudo -u ibra pm2 startup
    env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ibra --hp /home/ibra

    adduser --disabled-password --shell /usr/bin/fish --gecos 'Low Privileged User' lpu
    passwd -d lpu
    passwd -l lpu
    sudo -u lpu pm2 startup
    env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u lpu --hp /home/lpu

    passwd -d root
    passwd -l root
    chsh -s /usr/bin/fish root
    cp -r /etc/skel/. /root/
}

miscellious_setup(){
    bash -c 'mkdir -p /opt/server-certificates/self-cert && cd /opt/server-certificates/self-cert && openssl req -x509 -newkey rsa:2048 -keyout privkey.pem -out certificate.pem -days 3650 -subj "/CN=please-supply-valid-hostname" -nodes'
}

add_swap() {
    dd if=/dev/zero of=/swapfile bs=1048576 count=###SWAP_SIZE###
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
}

main_func() {
    install_packages
    install_starship
    setup_nodejs
    unzip_fs
    setup_users
    miscellious_setup
    ###SWAP_ON###add_swap
    print_ssh_key_fingerprint
    reboot
}

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi
main_func
