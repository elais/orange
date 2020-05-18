(define-module (elais packages cmt)
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages haskell-apps)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages ruby)
  #:use-module (gnu packages rsync)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xorg)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system ruby)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (rnrs io ports)
  #:use-module ((guix licenses) #:prefix license:)
  #:export (xf86-input-cmt))

(define libgestures
  (package
    (name "libgestures")
    (version "2.0.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/GalliumOS/libgestures.git")
                    (commit "7fa3186f3dc23f03998d7f2647812065e2e5c87e")))
              (sha256
               (base32 "0s3kphjd64zfnl9iqlzbbpdsdsilmz2d317sxic1crchla9rvwjj"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (add-after 'unpack 'patch-more-shebangs
           (lambda _
             (substitute* "Makefile"
               (("/usr/") "/")
               (("-Werror") "-Wno-error"))
             #t)))
       #:make-flags
       (list (string-append "DESTDIR=" (assoc-ref %outputs "out"))
             "LIBDIR=/lib")
       #:tests? #f))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("python" ,python-wrapper)))
    (inputs
     `(("jsoncpp" ,jsoncpp)
       ("glib" ,glib)))
    (home-page "https://github.com/GalliumOS/libgestures")
    (synopsis "ChromiumOS gestures library")
    (description "")
    (license (list license:non-copyleft "https://github.com/GalliumOS"))))

(define libevdevc
  (package
    (name "libevdevc")
    (version "2.0.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/GalliumOS/libevdevc.git")
                    (commit "c13b51efca59e9e5831351c2c3605b40da1f4c45")))
              (sha256
               (base32 "0b0ysvix0kmqrppjm3ac1jj6lk0fg5q0r77qday2zzx30vz859wc"))))
    (build-system gnu-build-system)
    (outputs (list "out"))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (add-after 'unpack 'patch-more-shebangs
           (lambda _
             (substitute* "common.mk"
               (("/bin/echo") (which "echo")))
             (substitute* "include/module.mk"
               (("/usr/") "/"))
             #t)))
       #:make-flags
       (list (string-append "DESTDIR=" (assoc-ref %outputs "out"))
             "LIBDIR=/lib")
       #:tests? #f))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("glib" ,glib)
       ("jsoncpp" ,jsoncpp)))
    (home-page "https://github.com/GalliumOS/libevdevc")
    (synopsis "ChromiumOS evdev library")
    (description "ChromiumOS evdev library")
    (license (list license:non-copyleft "https://github.com/GalliumOS"))))

(define-public xf86-input-cmt
   (package
     (name "xf86-input-cmt")
     (version "2.0.1")
     (source
      (origin
        (method git-fetch)
        (uri (git-reference
              (url "https://github.com/GalliumOS/xf86-input-cmt.git")
              (commit "6537abb193ab59a59b95c9511fa1c94d942b2c11")))
        (sha256
         (base32 "15qb2fhg64pqsnm0mmw3vmv1zavdqfxymch7j5w7msyd0038m4lb"))))
     (build-system glib-or-gtk-build-system)
     (arguments
      `(#:tests? #f
        #:configure-flags
        (list (string-append "--with-sdkdir="
                             (assoc-ref %outputs "out")
                             "/include/xorg"))
        #:phases
        (modify-phases %standard-phases
          (add-after 'install 'set-configs
            (lambda _
              (mkdir-p (string-append
                (assoc-ref %outputs "out")
                "/share/X11/xorg.conf.d"))
              (for-each
               (lambda (conf)
                 (with-directory-excursion "xorg-conf"
                   (copy-file conf
                              (string-append
                               (assoc-ref %outputs "out")
                               "/share/X11/xorg.conf.d/"
                               conf))))
               '("20-touchscreen.conf"
                 "40-touchpad-cmt.conf"
                 "50-touchpad-cmt-samus.conf"))
              #t)))))
     (native-inputs
      `(("pkg-config" ,pkg-config)))
     (inputs
      `(("xorg-server" ,xorg-server)
        ("libevdevc" ,libevdevc)
        ("util-macros" ,util-macros)
        ("xorgproto" ,xorgproto)))
     (propagated-inputs
      `(("libgestures" ,libgestures)))
     (home-page "https://github.com/GalliumOS/xf86-input-cmt")
     (synopsis "ChromiumOS X11 input driver")
     (description "")
     (license (list license:non-copyleft "https://github.com/GalliumOS"))))

xf86-input-cmt
