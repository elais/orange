;; This is an operating system configuration template
;; for a "desktop" setup with GNOME and Xfce where the
;; root partition is encrypted with LUKS.

(use-modules (gnu)
             (gnu system nss)
             (guix profiles)
             (nongnu packages cmt)
             (nongnu packages linux)
             (srfi srfi-1))

(use-service-modules desktop xorg ssh sound)
(use-package-modules certs gnome xorg gnome-xyz shells)

(define %samus/xorg-modules
  (map specification->package
       '("xf86-video-intel"
         "xf86-input-libinput"
         "xf86-input-evdev"
         "xf86-input-keyboard")))

(define %samus/packages
  (append
   (map specification->package
        '(;; CLI utilities
          "alsa-utils"
          "readline"
          "fish"
          ;; forgive me Stallman for I have sinned.
          "flatpak"
          ;; Global GUI stuff
          "emacs-next"
          "matcha-theme"
          "gnome-tweaks"
          "libvdpau-va-gl"
          "intel-vaapi-driver"
          ;; Media plugins
          "gst-plugins-good"
          "gst-plugins-bad"
          "gst-plugins-ugly"
          "gst-plugins-base"
          "gst-libav"
          "papirus-icon-theme"
          "nss-certs"
          "gvfs"))
   %base-packages))

(define %samus/services
  (cons* (service gnome-desktop-service-type)
         (service openssh-service-type)
         (service alsa-service-type)
         (set-xorg-configuration
          (xorg-configuration
           (modules %samus/xorg-modules)
           (keyboard-layout keyboard-layout)))
         %desktop-services))

(operating-system
  (host-name "samus")
  (timezone "America/Denver")
  (locale "en_US.utf8")
  (kernel linux)
  (firmware (list linux-firmware))
  (keyboard-layout (keyboard-layout "us" "altgr-intl"
                                    #:model "chromebook"))
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (target "/boot/efi")
                (keyboard-layout keyboard-layout)))

  (mapped-devices
   (list (mapped-device
          (source (uuid "bcacfe29-b1d1-4d35-a3ea-a9f3ccb9af86"))
          (target "guix")
          (type luks-device-mapping))))

  (file-systems (cons* (file-system
                         (device (file-system-label "guix"))
                         (mount-point "/")
                         (type "btrfs")
                         (dependencies mapped-devices))
                       (file-system
                         (device (file-system-label "boot"))
                         (mount-point "/boot/efi")
                         (type "vfat"))
                       %base-file-systems))

  (users (cons* (user-account
                 (name "elais")
                 (comment "Elais Player")
                 (shell #~(string-append #$fish "/bin/fish"))
                 (group "users")
                 (supplementary-groups
                  '("wheel" "netdev" "input" "audio" "video" "lp")))
                %base-user-accounts))
  (packages %samus/packages)
  (services %samus/services)
  (name-service-switch %mdns-host-lookup-nss))
