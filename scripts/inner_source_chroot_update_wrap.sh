#echo '192.99.32.76 repository.spike-pentesting.org' >>/etc/hosts
#equo up
#equo mask dev-ruby/packetfu@sabayonlinux.org

rm -rfv /etc/entropy/repositories.conf.d/*
#rm -rfv /etc/entropy/repositories.conf.d/entropy_sabayon-weekly

echo '[sabayonlinux.org]
desc = Sabayon Linux Official Repository
repo = http://pkg.sabayon.org#bz2
repo = http://pkg.repo.sabayon.org#bz2
enabled = true
pkg = http://mirror.umd.edu/sabayonlinux/entropy
pkg = http://mirror.freelydifferent.com/sabayon/entropy
pkg = http://dl.sabayon.org/entropy
pkg = http://bali.idrepo.or.id/sabayon/entropy
pkg = http://ftp.sh.cvut.cz/MIRRORS/sabayon/entropy
pkg = http://madura.idrepo.or.id/sabayon/entropy
pkg = http://sumbawa.idrepo.or.id/sabayon/entropy
pkg = http://www2.itti.ifce.edu.br/sabayon/entropy
pkg = http://riksun.riken.go.jp/pub/pub/Linux/sabayon/entropy
pkg = http://ftp.yz.yamagata-u.ac.jp/pub/linux/sabayonlinux/entropy
pkg = ftp://ftp.klid.dk/sabayonlinux/entropy
pkg = http://best.sabayon.org/entropy
pkg = http://cross-lfs.sabayonlinux.org/entropy
pkg = http://redir.sabayon.org/entropy
pkg = http://ftp.fsn.hu/pub/linux/distributions/sabayon/entropy
pkg = http://ftp.surfnet.nl/pub/os/Linux/distr/sabayonlinux/entropy
pkg = http://ftp.cc.uoc.gr/mirrors/linux/SabayonLinux/entropy
pkg = http://mirror.internode.on.net/pub/sabayon/entropy
pkg = http://sabayon.c3sl.ufpr.br/entropy
pkg = http://ftp.kddilabs.jp/Linux/packages/sabayonlinux/entropy
pkg = http://mirror.yandex.ru/sabayon/entropy
pkg = ftp://ftp.nluug.nl/pub/os/Linux/distr/sabayonlinux/entropy
pkg = http://debian.mirror.dkm.cz/sabayon/entropy
pkg = http://ftp.rnl.ist.utl.pt/pub/sabayon/entropy
pkg = http://mirror.clarkson.edu/sabayon/entropy
pkg = http://na.mirror.garr.it/mirrors/sabayonlinux/entropy
pkg = http://pkg.sabayon.org
' >> /etc/entropy/repositories.conf.d/entropy_sabayonlinux.org

echo '[spike]
desc = Spike Pentesting Sabayon Repository
repo = https://repository.spike-pentesting.org#bz2
#repo = https://mirror.spike-pentesting.org/mirrors/spike#bz2
enabled = true
#pkg = https://mirror.spike-pentesting.org/mirrors/spike
pkg = https://repository.spike-pentesting.org
' >> /etc/entropy/repositories.conf.d/entropy_spike
#sed -i 's:splash::g' /etc/default/sabayon-grub #plymouth fix
#grub2-mkconfig -o /boot/grub/grub.cfg
rsync -av -H -A -X --delete-during "rsync://rsync.at.gentoo.org/gentoo-portage/licenses/" "/usr/portage/licenses/"
ls /usr/portage/licenses -1 | xargs -0 > /etc/entropy/packages/license.accept
equo update --force


######END######
# check if a kernel update is needed
#kernel_target_pkg="sys-kernel/linux-spike"

#available_kernel=$(equo match "${kernel_target_pkg}" -q --showslot)
#echo
#echo "@@ Upgrading kernel to ${available_kernel}"
#echo
#safe_run kernel-switcher switch "${available_kernel}" || exit 1
equo remove "sys-kernel/linux-sabayon"
#safe_run kernel-switcher switch "${available_kernel}" || exit 1
safe_run kernel-switcher switch 'sys-kernel/linux-spike-3.18.10'|| exit 1

# now delete stale files in /lib/modules
for slink in $(find /lib/modules/ -type l); do
    if [ ! -e "${slink}" ]; then
        echo "Removing broken symlink: ${slink}"
        rm "${slink}" # ignore failure, best effort
        # check if parent dir is empty, in case, remove
        paren_slink=$(dirname "${slink}")
        paren_children=$(find "${paren_slink}")
        if [ -z "${paren_children}" ]; then
            echo "${paren_slink} is empty, removing"
            rmdir "${paren_slink}" # ignore failure, best effort
        fi
    fi
done


# keep /lib/modules clean at all times
for moddir in $(find /lib/modules -maxdepth 1 -type d -empty); do
    echo "Cleaning ${moddir} because it's empty"
    rmdir "${moddir}"
done




ls -liah /etc/entropy/repositories.conf.d/
cat /etc/entropy/repositories.conf.d/entropy_sabayonlinux.org

#mkdir -p /etc/entropy/packages/package.mask.d/
#Masking sabayon packages
REPLACEMENT=">=sys-apps/openrc-0.9@sabayon-limbo
>=sys-apps/openrc-0.9@sabayonlinux.org
>=sys-apps/openrc-0.9@sabayon-weekly
>=app-misc/sabayonlive-tools-2.3@sabayon-limbo
>=app-misc/sabayonlive-tools-2.3@sabayonlinux.org
>=app-misc/sabayonlive-tools-2.3@sabayon-weekly
>=app-misc/sabayon-live-1.3@sabayon-limbo
>=app-misc/sabayon-live-1.3@sabayonlinux.org
>=app-misc/sabayon-live-1.3@sabayon-weekly
>=app-misc/sabayon-skel-1@sabayon-limbo
>=app-misc/sabayon-skel-1@sabayonlinux.org
>=app-misc/sabayon-skel-1@sabayon-weekly
>=sys-boot/grub-1.00@sabayon-limbo
>=sys-boot/grub-1.00@sabayonlinux.rg
>=sys-boot/grub-1.00@sabayon-weekly
>=kde-base/oxygen-icons-4.9.2@sabayon-weekly
>=kde-base/oxygen-icons-4.9.2@sabayonlinux.org
>=kde-base/oxygen-icons-4.9.2@sabayon-limbo
>=x11-themes/gnome-colors-common-5.5.1@sabayon-weekly
>=x11-themes/gnome-colors-common-5.5.1@sabayonlinux.org
>=x11-themes/gnome-colors-common-5.5.1@sabayon-limbo
>=x11-themes/tango-icon-theme-0.8.90@sabayon-weekly
>=x11-themes/tango-icon-theme-0.8.90@sabayonlinux.org
>=x11-themes/tango-icon-theme-0.8.90@sabayon-limbo
>=x11-themes/elementary-icon-theme-2.7.1@sabayon-weekly
>=x11-themes/elementary-icon-theme-2.7.1@sabayonlinux.org
>=x11-themes/elementary-icon-theme-2.7.1@sabayon-limbo
>=lxde-base/lxdm-0.4.1-r5@sabayon-weekly
>=lxde-base/lxdm-0.4.1-r5@sabayonlinux.org
>=lxde-base/lxdm-0.4.1-r5@sabayon-limbo
>=sys-apps/gpu-detector-1@sabayon-weekly
>=sys-apps/gpu-detector-1@sabayonlinux.org
>=sys-apps/gpu-detector-1@sabayon-limbo
>=app-admin/anaconda-0.1@sabayon-weekly
>=app-admin/anaconda-0.1@sabayonlinux.org
>=app-admin/anaconda-0.1@sabayon-limbo
>=sys-boot/plymouth-1@sabayon-weekly
>=sys-boot/plymouth-1@sabayonlinux.org
>=sys-boot/plymouth-1@sabayon-limbo
>=x11-themes/sabayon-artwork-core-1@sabayon-weekly
>=x11-themes/sabayon-artwork-core-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-core-1@sabayon-limbo
>=x11-themes/sabayon-artwork-extra-1@sabayon-weekly
>=x11-themes/sabayon-artwork-extra-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-extra-1@sabayon-limbo
>=x11-themes/sabayon-artwork-gnome-1@sabayon-weekly
>=x11-themes/sabayon-artwork-gnome-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-gnome-1@sabayon-limbo
>=x11-themes/sabayon-artwork-grub-1@sabayon-weekly
>=x11-themes/sabayon-artwork-grub-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-grub-1@sabayon-limbo
>=x11-themes/sabayon-artwork-isolinux-1@sabayon-weekly
>=x11-themes/sabayon-artwork-isolinux-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-isolinux-1@sabayon-limbo
>=x11-themes/sabayon-artwork-kde-1@sabayon-weekly
>=x11-themes/sabayon-artwork-kde-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-kde-1@sabayon-limbo
>=x11-themes/sabayon-artwork-loo-1@sabayon-weekly
>=x11-themes/sabayon-artwork-loo-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-loo-1@sabayon-limbo
>=x11-themes/sabayon-artwork-lxde-1@sabayon-weekly
>=x11-themes/sabayon-artwork-lxde-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-lxde-1@sabayon-limbo
>=app-misc/anaconda-runtime-1.1-r1@sabayon-weekly
>=app-misc/anaconda-runtime-1.1-r1@sabayonlinux.org
>=app-misc/anaconda-runtime-1.1-r1@sabayon-limbo
"
safe_run equo update --force || exit 1


# metasploit still targets ruby19

 masks=(
=dev-ruby/actionpack@sabayonlinux.org
dev-ruby/builder@sabayonlinux.org
dev-ruby/rails-html-sanitizer@sabayonlinux.org
dev-ruby/rails-dom-testing@sabayonlinux.org
dev-ruby/activemodel@sabayonlinux.org
dev-ruby/activerecord@sabayonlinux.org
dev-ruby/rails-deprecated_sanitizer@sabayonlinux.org
=net-misc/networkmanager-1.0.0@sabayonlinux.org
=gnome-extra/nm-applet-1.0.0@sabayonlinux.org
#x11-themes/sabayon-artwork-core
#x11-themes/sabayon-artwork-grub
#x11-themes/sabayon-artwork-isolinux
#x11-themes/sabayon-artwork-extra
#x11-themes/sabayon-artwork-kde
#x11-themes/sabayon-artwork-lxde
sys-boot/grub@sabayonlinux.org
dev-ruby/rubygems@sabayonlinux.org
dev-ruby/tilt@sabayonlinux.org
dev-ruby/tzinfo@sabayonlinux.org
dev-ruby/bundler@sabayonlinux.org
dev-ruby/loofah@sabayonlinux.org
dev-ruby/arel@sabayonlinux.org
dev-ruby/mime-types@sabayonlinux.org
dev-ruby/actionpack@sabayonlinux.org
dev-ruby/activesupport@sabayonlinux.org
dev-ruby/ffi@sabayonlinux.org
www-servers/thin@sabayonlinux.org
dev-ruby/daemons@sabayonlinux.org
dev-ruby/ruby_parser@sabayonlinux.org
dev-ruby/actionview@sabayonlinux.org
dev-ruby/execjs@sabayonlinux.org
dev-ruby/mime-types@sabayonlinux.org
dev-ruby/packetfu@sabayonlinux.org
)

    for mask in "${masks[@]}"; do
        equo mask ${mask}
    done

export ETP_NONINTERACTIVE=1
safe_run equo upgrade || exit 1
equo upgrade --purge || exit 1

equo install x11-misc/lightdm
equo mask sabayon-skel sabayon-version sabayon-artwork-grub sabayon-live
equo remove sabayon-artwork-grub sabayon-artwork-core sabayon-artwork-isolinux sabayon-version sabayon-skel sabayon-live sabayonlive-tools sabayon-live  sabayon-artwork-gnome --nodeps --force-system
equo remove linux-sabayon:$(eselect kernel list | grep "*" | awk '{print $2}' | cut -d'-' -f2) --nodeps --configfiles
equo mask sabayon-version

equo install sys-boot/grub::spike

equo install  --multifetch 10 spike/spike::spike

# ruby20 as default
eselect ruby set ruby20
equo remove sabayon-artwork-grub sabayon-artwork-core sabayon-artwork-isolinux sabayon-version sabayon-skel sabayon-live sabayonlive-tools sabayon-live  sabayon-artwork-gnome --nodeps --force-system
equo i spike-artwork-core
sed -i 's:sabayon:spike:g' /etc/plymouth/plymouthd.conf

wget http://repository.spike-pentesting.org/distfiles/anaconda-artwork.tar.gz -O /tmp/anaconda-artwork.tar.gz
tar xvf /tmp/anaconda-artwork.tar.gz  -C /usr/share/anaconda/pixmaps/
rm -rfv /tmp/anaconda-artwork.tar.gz


#Overlayfs and squashfs errors for now, manually forcing 3.18.10
equo remove linux-sabayon
equo i spike/spike
#safe_run kernel-switcher switch 'sys-kernel/linux-spike:3.18'|| exit 1
safe_run kernel-switcher switch 'sys-kernel/linux-spike-3.18.10'|| exit 1
safe_run equo i x11-drivers/xf86-video-virtualbox-4.3.26#3.18.0-spike  app-emulation/virtualbox-guest-additions-4.3.26#3.18.0-spike  app-emulation/virtualbox-modules-4.3.26#3.18.0-spike 
safe_run equo i  app-laptop/nvidiabl-0.72#3.18.0-spike x11-drivers/nvidia-drivers-346.35#3.18.0-spike x11-drivers/nvidia-userspace-346.35::spike
# now delete stale files in /lib/modules
for slink in $(find /lib/modules/ -type l); do
    if [ ! -e "${slink}" ]; then
        echo "Removing broken symlink: ${slink}"
        rm "${slink}" # ignore failure, best effort
        # check if parent dir is empty, in case, remove
        paren_slink=$(dirname "${slink}")
        paren_children=$(find "${paren_slink}")
        if [ -z "${paren_children}" ]; then
            echo "${paren_slink} is empty, removing"
            rmdir "${paren_slink}" # ignore failure, best effort
        fi
    fi
done


# keep /lib/modules clean at all times
for moddir in $(find /lib/modules -maxdepth 1 -type d -empty); do
    echo "Cleaning ${moddir} because it's empty"  
    rmdir "${moddir}"
done






echo '
# useradd defaults file
GROUP=100
HOME=/home
INACTIVE=-1
EXPIRE=
SHELL=/bin/zsh
SKEL=/etc/skel
' > /etc/default/useradd

equo query list installed -qv > /etc/sabayon-pkglist




