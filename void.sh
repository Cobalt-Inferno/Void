#!/bin/bash
INSTALL_QEMU_KVM=false
INSTALL_X11=false
INSTALL_STEAM=false


ENABLED_REPOS=(
    MULTILIB
    NONFREE
)
FETCH_FLAGS=(
    GPU
)

fetch() {
    case "$1" in
        GPU)
            if [[ "$(lspci | grep VGA)" =~ "NVIDIA" ]]; then
                "NVIDIA"
            fi
            ;;
        *)
            echo -e "UNKNOWN"
            ;;
    esac
}    

_X11_PKGS=(xorg xinit xtools libX11-devel base-devel libXinerama-devel freetype-devel libXft-devel)
_QEMU_KVM_PKGS=(virt-manager dbus qemu libvirt)

if [ "$INSTALL_QEMU_KVM" = true ]; then
    for i in "${_QEMU_KVM_PKGS[@]}"; do
        sudo xbps-install "$i"
    done
    sudo ln -s /etc/sv/libvirtd /var/service
    sudo ln -s /etc/sv/virtlockd /var/service
    sudo ln -s /etc/sv/virtlogd /var/service
    if [ "$(id -u)" != "0" ]; then
        sudo gpasswd -a "$USER" libvirt
        sudo gpasswd -a "$USER" kvm
        sudo virsh net-start default
        sudo virsh net-autostart default
    fi
fi

if [ "$INSTALL_X11" = true ]; then
    for i in "${_X11_PKGS[@]}"; do
        sudo xbps-install "$i"
    done
fi




if [ "$INSTALL_STEAM" = true ]; then
    "echo -e x"
fi




for i in "${ENABLED_REPOS[@]}"; do
    case "$i" in

        MULTILIB)
            sudo xbps-install -Suyv void-repo-multilib
            sudo xbps-install -Suyv
            ;;
        NONFREE)
            sudo xbps-install -Suyv void-repo-nonfree
            sudo xbps-install -Suyv
            ;;
        *)
            echo -e "Unknown!"
            ;;
    esac
done










