(define-module (elais packages emacs-xyz)
  :#use-modules (gnu)
  :#use-modules (gnu packages emacs-xyz)
  :#use-modules (guix build-system emacs)
  :#use-modules (guix download)
  :#use-modules ((guix licenses) #:prefix license:))

(define-public emacs-flymake
  (package
    (name "emacs-flymake")
    (version "1.0.8")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://elpa.gnu.org/packages/flymake-"
             version
             ".el"))
       (sha256
        (base32
         "1hqxrqb227v4ncjjqx8im3c4mhg8w5yjbz9hpfcm5x8xnr2yd6bp"))))
    (build-system emacs-build-system)
    (home-page
     "http://elpa.gnu.org/packages/flymake.html")
    (synopsis
     "A universal on-the-fly syntax checker")
    (description
     "Flymake is a minor Emacs mode performing on-the-fly syntax checks.

Flymake collects diagnostic information for multiple sources,
called backends, and visually annotates the relevant portions in
the buffer.

This file contains the UI for displaying and interacting with the
results produced by these backends, as well as entry points for
backends to hook on to.

The main interactive entry point is the `flymake-mode' minor mode,
which periodically and automatically initiates checks as the user
is editing the buffer.  The variables `flymake-no-changes-timeout',
`flymake-start-on-flymake-mode' give finer control over the events
triggering a check, as does the interactive command  `flymake-start',
which immediately starts a check.

Shortly after each check, a summary of collected diagnostics should
appear in the mode-line.  If it doesn't, there might not be a
suitable Flymake backend for the current buffer's major mode, in
which case Flymake will indicate this in the mode-line.  The
indicator will be `!' (exclamation mark), if all the configured
backends errored (or decided to disable themselves) and `?'
(question mark) if no backends were even configured.

For programmers interested in writing a new Flymake backend, the
docstring of `flymake-diagnostic-functions', the Flymake manual,
and the code of existing backends are probably a good starting
point.

The user wishing to customize the appearance of error types should
set properties on the symbols associated with each diagnostic type.
The standard diagnostic symbols are `:error', `:warning' and
`:note' (though a specific backend may define and use more).  The
following properties can be set:

* `flymake-bitmap', an image displayed in the fringe according to
`flymake-fringe-indicator-position'.  The value actually follows
the syntax of `flymake-error-bitmap' (which see).  It is overridden
by any `before-string' overlay property.

* `flymake-severity', a non-negative integer specifying the
diagnostic's severity.  The higher, the more serious.  If the
overlay property `priority' is not specified, `severity' is used to
set it and help sort overlapping overlays.

* `flymake-overlay-control', an alist ((OVPROP . VALUE) ...) of
further properties used to affect the appearance of Flymake
annotations.  With the exception of `category' and `evaporate',
these properties are applied directly to the created overlay.  See
Info Node `(elisp)Overlay Properties'.

* `flymake-category', a symbol whose property list is considered a
default for missing values of any other properties.  This is useful
to backend authors when creating new diagnostic types that differ
from an existing type by only a few properties.  The category
symbols `flymake-error', `flymake-warning' and `flymake-note' make
good candidates for values of this property.

For instance, to omit the fringe bitmap displayed for the standard
`:note' type, set its `flymake-bitmap' property to nil:

  (put :note 'flymake-bitmap nil)

To change the face for `:note' type, add a `face' entry to its
`flymake-overlay-control' property.

  (push '(face . highlight) (get :note 'flymake-overlay-control))

If you push another alist entry in front, it overrides the previous
one.  So this effectively removes the face from `:note'
diagnostics.

  (push '(face . nil) (get :note 'flymake-overlay-control))

To erase customizations and go back to the original look for
`:note' types:

  (cl-remf (symbol-plist :note) 'flymake-overlay-control)
  (cl-remf (symbol-plist :note) 'flymake-bitmap)")
    (license license:gpl3+)))

(define-public emacs-jsonrpc
  (package
    (name "emacs-jsonrpc")
    (version "1.0.11")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://elpa.gnu.org/packages/jsonrpc-"
             version
             ".el"))
       (sha256
        (base32
         "04cy1mqd6y8k5lcpg076szjk9av9345mmsnzzh6vgbcw3dcgbr23"))))
    (build-system emacs-build-system)
    (home-page
     "http://elpa.gnu.org/packages/jsonrpc.html")
    (synopsis "JSON-RPC library")
    (description
     "This library implements the JSONRPC 2.0 specification as described
in http://www.jsonrpc.org/.  As the name suggests, JSONRPC is a
generic Remote Procedure Call protocol designed around JSON
objects.  To learn how to write JSONRPC programs with this library,
see Info node `(elisp)JSONRPC'.\"

This library was originally extracted from eglot.el, an Emacs LSP
client, which you should see for an example usage.")
    (license license:gpl3+)))

(define-public emacs-eglot
  (package
    (name "emacs-eglot")
    (version "1.6")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://elpa.gnu.org/packages/eglot-"
             version
             ".tar"))
       (sha256
        (base32
         "15hd6sx7qrpvlvhwwkcgdiki8pswwf4mm7hkm0xvznskfcp44spx"))))
    (build-system emacs-build-system)
    (propagated-inputs
     `(("emacs-jsonrpc" ,emacs-jsonrpc)
       ("emacs-flymake" ,emacs-flymake)))
    (home-page "https://github.com/joaotavora/eglot")
    (synopsis
     "Client for Language Server Protocol (LSP) servers")
    (description
     "Simply M-x eglot should be enough to get you started, but here's a
little info (see the accompanying README.md or the URL for more).

M-x eglot starts a server via a shell-command guessed from
`eglot-server-programs', using the current major-mode (for whatever
language you're programming in) as a hint.  If it can't guess, it
prompts you in the mini-buffer for these things.  Actually, the
server needen't be locally started: you can connect to a running
server via TCP by entering a <host:port> syntax.

Anyway, if the connection is successful, you should see an `eglot'
indicator pop up in your mode-line.  More importantly, this means
current *and future* file buffers of that major mode *inside your
current project* automatically become \\\"managed\\\" by the LSP
server, i.e.  information about their contents is exchanged
periodically to provide enhanced code analysis via
`xref-find-definitions', `flymake-mode', `eldoc-mode',
`completion-at-point', among others.

To \"unmanage\" these buffers, shutdown the server with M-x
eglot-shutdown.

You can also do:

  (add-hook 'foo-mode-hook 'eglot-ensure)

To attempt to start an eglot session automatically everytime a
foo-mode buffer is visited.")
    (license license:gpl3+)))

(define-public emacs-company-prescient
  (package
    (name "emacs-company-prescient")
    (version "20200404.1550")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://melpa.org/packages/company-prescient-"
             version
             ".el"))
       (sha256
        (base32
         "098k5akqig2bh1r70240lyzwsv8zj8xzn9ldxc01h9hz29cslgkd"))))
    (build-system emacs-build-system)
    (propagated-inputs
     `(("emacs-prescient" ,emacs-prescient)
       ("emacs-company" ,emacs-company)))
    (home-page
     "https://github.com/raxod502/prescient.el")
    (synopsis "prescient.el + Company")
    (description
     "company-prescient.el provides an interface for using prescient.el
to sort Company completions. To enable its functionality, turn on
`company-prescient-mode' in your init-file or interactively.

Note that company-prescient.el does not change the filtering
behavior of Company. This is because that can't be done without
updating each Company backend individually.

For more information, see https://github.com/raxod502/prescient.el.
")
    (license #f)))

(define-public emacs-selectrum-prescient
  (package
    (name "emacs-selectrum-prescient")
    (version "20200404.1550")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://melpa.org/packages/selectrum-prescient-"
             version
             ".el"))
       (sha256
        (base32
         "155bsilm5db16a47vpnvylwy031rwsfzvyw76mxsc343aggiv16g"))))
    (build-system emacs-build-system)
    (propagated-inputs
     `(("emacs-prescient" ,emacs-prescient)
       ("emacs-selectrum" ,emacs-selectrum)))
    (home-page
     "https://github.com/raxod502/prescient.el")
    (synopsis "Selectrum integration")
    (description
     "selectrum-prescient.el provides an interface for using prescient.el
to sort and filter candidates in Selectrum menus. To enable its
functionality, turn on `selectrum-prescient-mode' in your init-file
or interactively.

For more information, see https://github.com/raxod502/prescient.el.
")
    (license #f)))

(define-public emacs-boon
  (package
    (name "emacs-boon")
    (version "20200507.1851")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://melpa.org/packages/boon-"
             version
             ".tar"))
       (sha256
        (base32
         "0yxfgm94zlykgqaqi2yvrg3l5d327cxzcgxkw83b30xilw10nyk4"))))
    (build-system emacs-build-system)
    (propagated-inputs
     `(("emacs-expand-region" ,emacs-expand-region)
       ("emacs-dash" ,emacs-dash)
       ("emacs-multiple-cursors" ,emacs-multiple-cursors)
       ("emacs-spaceline" ,emacs-spaceline)))
    (home-page "unspecified")
    (synopsis "Ergonomic Command Mode for Emacs.")
    (description
     "Boon brings modal editing capabilities to Emacs and...

- It tries to be as ergonomic as possible.
- It remains lightweight (~300 loc for its core.)
- It attempts to integrate with Emacs as smoothly as possible
")
    (license license:gpl3)))
