;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2013 Ludovic Courtès <ludo@gnu.org>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (gnu packages custom_chapel)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages)
;  #:use-module (gnu packages jemalloc)
;  #:use-module (gnu packages llvm)
  #:use-module (gnu packages mpi)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python))

(define-public chapel
  (package
    (name "chapel")
    (version "1.26.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/chapel-lang/chapel")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0qqz4jx40ri89xdkzmlf9p94jggwsy4hrn2xvbx2abr2akqkxslj"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f
       #:phases
        (modify-phases %standard-phases
          (replace 'configure
           (lambda _
	     (let ((out (assoc-ref %outputs "out")))
               (mkdir-p out)
               (setenv "CHPL_HWLOC" "system")
               (setenv "CHPL_LLVM" "none")
               (setenv "CHPL_MEM" "cstdlib")
               (setenv "CHPL_TASKS" "fifo")
               (invoke "./configure"
                       (string-append "--prefix=" out))))))))
;    (inputs
;     `(("hwloc" ,hwloc-1 "lib")
;       ("jemalloc" ,jemalloc)))
    (native-inputs (list pkg-config python))
    (propagated-inputs
     `(("hwloc" ,hwloc-1 "lib")))
;    (propagated-inputs (list clang-11 clang-runtime-11 llvm-11))
    (home-page "https://github.com/chapel-lang/chapel")
    (synopsis "")
    (description "")
    (license license:expat)))
