{stdenv, getopt}:

stdenv.mkDerivation {
  name = "nixproc-launchd-tools";
  buildCommand = ''
    mkdir -p $out/bin

    sed -e "s|/bin/bash|$SHELL|" \
      -e "s|@getopt@|${getopt}/bin/getopt|" \
      -e "s|@commonchecks@|${../commonchecks}|" \
      ${./nixproc-launchd-switch.in} > $out/bin/nixproc-launchd-switch
    chmod +x $out/bin/nixproc-launchd-switch

    sed -e "s|/bin/bash|$SHELL|" \
      -e "s|@getopt@|${getopt}/bin/getopt|" \
      -e "s|@commonchecks@|${../commonchecks}|" \
      -e "s|@readlink@|$(type -p readlink)|" \
      ${./nixproc-launchd-deploy.in} > $out/bin/nixproc-launchd-deploy
    chmod +x $out/bin/nixproc-launchd-deploy
  '';
}
