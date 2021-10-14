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

(define-module (gnu packages custom_havoqgt)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (gnu packages)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages check)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages mpi)
  #:use-module (gnu packages ssh))

(define-public metall
  (let* ((commit "d4dfd5b45cade1388d94f82e75b90c6a8f9044a2")
         (revision "1"))
    (package
     (name "metall")
     (version (git-version "0.19" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/LLNL/metall")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0ciap7kqa0px37zvv122g85knb6sddwqxgck6dp96w08yhlnnqml"))
              (patches
               (search-patches
                "metall-add-language.patch"))))
     (build-system cmake-build-system)
     (arguments
      '(#:configure-flags
        '("-DBUILD_BENCH=ON"
          "-DBUILD_C=OFF"
          "-DBUILD_DOC=ON"
          "-DBUILD_EXAMPLE=ON"
          "-DBUILD_TEST=ON"
          "-DBUILD_UTILITY=ON"
          "-DBUILD_VERIFICATION=ON"
          "-DRUN_LARGE_SCALE_TEST=ON"
          "-DSKIP_DOWNLOAD_GTEST=ON")))
     (inputs
      (list boost doxygen googletest openmpi))
     (home-page "https://github.com/LLNL/metall")
     (synopsis "Meta allocator for persistent memory")
     (description "")
     (license license:expat))))

(define-public havoqgt
  (let* ((commit "2e8b2a8a0ed764188079f32b1b01b8b24c81e20b")
         (revision "1"))
    (package
     (name "havoqgt")
     (version (git-version "0.0" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/LLNL/havoqgt")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1s1hggzj6shqrch3h6l3kcg3ganjlqfd5pvlgz4bz19al1d39cy0"))
              (patches
               (search-patches
                "havoqgt-fix-build-errors.patch"))))
     (build-system cmake-build-system)
     (arguments
      '(#:configure-flags
        '("-DCMAKE_CXX_FLAGS=-std=c++17 -lrt -lstdc++fs -lpthread"
          "-DUSE_HDF5=TRUE")))
     (inputs
      (list boost metall))
     (propagated-inputs
      (list openmpi openssh))
     (home-page "https://github.com/LLNL/havoqgt")
     (synopsis "")
     (description "")
     (license license:expat))))
