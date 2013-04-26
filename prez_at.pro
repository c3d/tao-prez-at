
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
node_modules.commands = npm install socket.io-client@0.9.11 winston@0.6.2 && touch node_modules/.inst
QMAKE_EXTRA_TARGETS += node_modules
distclean_rm_node_modules.commands = rm -rf ./node_modules/* ./node_modules/.inst
distclean.depends = distclean_rm_node_modules
QMAKE_EXTRA_TARGETS += distclean distclean_rm_node_modules

# Install NodeJS modules
install_node_modules.files = ./node_modules
install_node_modules.path  = $${MODINSTPATH}
QMAKE_EXTRA_TARGETS += install_node_modules
INSTALLS += install_node_modules
