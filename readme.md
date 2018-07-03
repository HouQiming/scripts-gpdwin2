# Scripts for GPD Win 2

This is for people who want to carry an entire Windows system around in the GPD and occasionally use it on a more powerful computer. With this setup, you can:
- Play games installed on the GPD from a different computer
- Use the GPD as a keylogger-proof (though expensive) encrypted SSD
- Borrow other people's laptop as your GPD docking station :)

## System Setup

First you have to install Ubuntu 18 with the default user named 'a'.

Then install my kernel fork at https://github.com/houqiming/linux-gpdwin2

Then edit `/etc/default/grub` and `update-grub`:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash acpi_serialize fbcon=rotate:1 modprobe.blacklist=sdhci,cqhci,sdhci_pci,sdhci-pci,mmc_core,mmc-core module_blacklist=sdhci,cqhci,sdhci_pci,sdhci-pci,mmc_core,mmc-core i915.enable_gvt=1 kvm.ignore_msrs=1 intel_iommu=on"
```

Then copy everything from this repo to `~/`

Then build qemu 2.12.0 with GTK and libusb support. Use `qemu/conf.sh` to configure it.

Then you need a Windows To Go VM image at `/home/a/vm/win10_clean.qcow2`. This would be your "main system". This VM should be installed in a default-setting VM or converted from a dd image.

Make the following BIOS tweaks:
- Advanced
  - Intel RC ACPI Settings
    - Type C Support [Enabled]
- Chipset
  - System Agent (SA) Configuration
    - Graphics Configuration
      - Aperture Size [1024MB]
  - PCH-IO Configuration
    - USB Configuration
      - xDCI Support [Enabled]
    - DCI enable (HDCIEN) [Enabled]

Now you can:

## Boot the VM on a Physical PC

- Power off the PC
- Connect the GPD to the PC using a USB type C to type A cable
  - Make sure you use an unpowered port
- Run `mode_reset.sh`
- Run `make_disk.sh`
- Turn on the PC
- Now the PC should detect the GPD as an external hard drive and boot your VM image

If it doesn't work, try the following remedies randomly:
- Rerun `mode_reset.sh`
- Reboot the GPD
- Pull the PC's plug
- Yank out the USB cable and plug it back in

## Boot the VM on GPD

```
cd vm
./start_vm.sh
```

I've set up:
- Intel GVT-g virtual GPU that "just works"
- Audio / joystick passthrough
- Shared folder for driver installation and stuff

Windows To Go needs to install a big driver during the first boot, during which there's no display. Be patient.

If the display resolution were weird, use Intel HD Graphics to set it to 1280x720. Windows display settings won't work.

## Credits

- Hans de Goede for blogging about the dwc3 on the GPD in the first place, and his hard work to support various GPD components in the kernel
- Xilinx for most of the USB-related work
- The Intel GVT team for their GPU excellent virtualization work
- I did some kernel hacking myself to fix the UCSI driver, the dwc3 driver, and the GVT virtual display
