{ createCygrunsrvParams
, stdenv
, writeTextFile
, runtimeDir ? "/var/run"
}:

{ name
, description
, initialize
, daemon
, daemonArgs
, instanceName
, pidFile
, foregroundProcess
, foregroundProcessArgs
, path
, environment
, directory
, umask
, nice
, user
, dependencies
, credentials
, overrides
, postInstall
}:

# TODO: credentials
# TODO: directory unused
# TODO: umask unused
# TODO: nice unused
# TODO: user unused

let
  generateForegroundProxy = import ./generate-foreground-proxy.nix {
    inherit stdenv writeTextFile;
  };
in
createCygrunsrvParams (stdenv.lib.recursiveUpdate ({
  inherit name environment dependencies postInstall;

  environmentPath = path;

  path = if foregroundProcess != null then
    if initialize == "" then foregroundProcess
    else generateForegroundProxy {
      wrapDaemon = false;
      executable = foregroundProcess;
      inherit name initialize runtimeDir pidFile stdenv;
    }
  else generateForegroundProxy {
    wrapDaemon = true;
    executable = daemon;
    inherit name initialize runtimeDir pidFile stdenv;
  };

  args = if foregroundProcess != null then foregroundProcessArgs else daemonArgs;
}) overrides)
