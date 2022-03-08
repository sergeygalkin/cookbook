
This is config for https://wiki.gentoo.org/wiki/Lenovo_ThinkBook_15_G2_ITL for kernel 5.16.12
The config IS NOT OPTIMAL for hradware. It's baesed on Ubuntu 20.04.4 kernel config and have a lot of unused drivers

dracut image
```
# ls -lh /boot/initramfs-5.16.12.img 
-rwxr-xr-x 1 root root 121M Mar  8 19:41 /boot/initramfs-5.16.12.img
```

```
gals-rolos ~ # du -sh /lib/modules/5.16.12-gentoo/
1.7G	/lib/modules/5.16.12-gentoo/
```
