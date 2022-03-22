
This is kernels configs for https://wiki.gentoo.org/wiki/Lenovo_ThinkBook_15_G2_ITL

```
╰─ ls -lh /boot/*5.16.14* | awk '{print $5" "$9}'
28M /boot/initramfs-5.16.14.img
7.7M /boot/kernel-5.16.14
╰─ du -sh /lib/modules/5.16.14-gentoo
86M     /lib/modules/5.16.14-gentoo
```

```
╰─ ls -lh /boot/*5.17.0* | awk '{print $5" "$9}'
28M /boot/initramfs-5.17.0.img
7.7M /boot/kernel-5.17.0
╰─ du -sh /lib/modules/5.17.0-gentoo
86M     /lib/modules/5.17.0-gentoo
```
