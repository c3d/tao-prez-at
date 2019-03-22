# ******************************************************************************
# prez_at.pro                                                      Tao3D project
# ******************************************************************************
#
# File description:
#
#
#
#
#
#
#
#
# ******************************************************************************
# This software is licensed under the GNU General Public License v3
# (C) 2013, Baptiste Soulisse <baptiste.soulisse@taodyne.com>
# (C) 2013-2014,2019, Christophe de Dinechin <christophe@dinechin.org>
# (C) 2013, Jérôme Forissier <jerome@taodyne.com>
# ******************************************************************************
# This file is part of Tao3D
#
# Tao3D is free software: you can r redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Tao3D is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Tao3D, in a file named COPYING.
# If not, see <https://www.gnu.org/licenses/>.
# ******************************************************************************

MODINSTDIR = prez_at

include(../modules.pri)

OTHER_FILES = prez_at.xl prez.at.js
OTHER_FILES += doc/prez_at.doxy.h doc/Doxyfile.in

# Icon is a mix of:
# 1. http://www.iconfinder.com/icondetails/17829/32/global_internet_network_planet_rank_seo_web_icon
#    Author: Everaldo Coelho - http://www.everaldo.com/
#    License: LGPL
# 2. http://www.iconfinder.com/icondetails/66994/32/right_icon
#    Author: Nahas M.A. - http://nahas-pro.deviantart.com/
#    License: Free for commercial use
INSTALLS    += thismod_icon
INSTALLS    -= thismod_bin


QMAKE_SUBSTITUTES = doc/Doxyfile.in
QMAKE_DISTCLEAN = doc/Doxyfile
DOXYFILE = doc/Doxyfile
DOXYLANG = en,fr
include(../modules_doc.pri)

install_extra.files = prez.at.js
install_extra.path = $${MODINSTPATH}
QMAKE_EXTRA_TARGETS += install_extra
INSTALLS += install_extra

# node_modules: the NodeJS modules directory
# Created by 'npm install' which REQUIRES AN INTERNET CONNECTION
PRE_TARGETDEPS = node_modules/.inst
node_modules.target = node_modules/.inst
node_modules.commands = npm install socket.io-client@0.9.11 winston@0.6.2 || npm install socket.io-client@0.9.11 winston@0.6.2 || npm install socket.io-client@0.9.11 winston@0.6.2 && touch node_modules/.inst
QMAKE_EXTRA_TARGETS += node_modules
distclean_rm_node_modules.commands = rm -rf ./node_modules/* ./node_modules/.inst
distclean.depends = distclean_rm_node_modules
QMAKE_EXTRA_TARGETS += distclean distclean_rm_node_modules

# Install NodeJS modules
install_node_modules.files = ./node_modules
install_node_modules.path  = $${MODINSTPATH}
QMAKE_EXTRA_TARGETS += install_node_modules
INSTALLS += install_node_modules
