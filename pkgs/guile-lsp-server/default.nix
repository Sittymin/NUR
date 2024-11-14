{ lib
, stdenv
, guile
, pkg-config
, automake
, autoconf
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "guile-lsp-server";
  version = "0.4.5";

  src = builtins.fetchGit {
    url = "https://codeberg.org/rgherdt/scheme-lsp-server.git";
    ref = "${version}";
    rev = "81d2b3613ea48f345e868d191bbf1b92686cbe60";
  };

  srfi = fetchTarball {
    url = "https://codeberg.org/rgherdt/srfi/archive/main.tar.gz";
    sha256 = "0k8libc4nfd0k0kibpdjvmgazpf8p71sjgpfg4ryv8n3z6zkdwwj";
  };
  irregex = fetchTarball {
    url = "http://synthcode.com/scheme/irregex/irregex-0.9.10.tar.gz";
    sha256 = "0whfa255pfnml5vmwag0bkx7bz93d4v17gjyhwhq0aipqsm9pqnd";
  };
  json-rpc = fetchTarball {
    url = "https://codeberg.org/rgherdt/scheme-json-rpc/archive/master.tar.gz";
    sha256 = "0356hm6phcfgvwvx3ys6b927v40jzb7qrfgvql7g78na24zp2cmi";
  };

  nativeBuildInputs = [
    guile
    pkg-config
    automake
    autoconf
    makeWrapper
  ];

  postUnpack = ''
    build_dir=`pwd`
    mkdir -p $build_dir
    site_dir=$build_dir/share/guile/site/3.0;
    lib_dir=$build_dir/lib/guile/3.0/site-ccache;
    mkdir -p $site_dir
    mkdir -p $lib_dir
    export GUILE_LOAD_PATH=.:$site_dir:...:$GUILE_LOAD_PATH
    export GUILE_LOAD_COMPILED_PATH=.:$lib_dir:...:$GUILE_LOAD_COMPILED_PATH
    # for guild compile
    export XDG_CACHE_HOME=$build_dir/cache
    echo "==================="

    echo "install srfi-145"
    mkdir -p $site_dir/srfi
    cp ${srfi}/srfi/srfi-145.scm $site_dir/srfi
    echo "==================="

    echo "install irregex"
    mkdir -p $site_dir/rx/source
    mkdir -p $lib_dir/rx/source
    cp ${irregex}/irregex-guile.scm $site_dir/rx/irregex.scm
    cp ${irregex}/irregex.scm $site_dir/rx/source/irregex.scm
    cp ${irregex}/irregex-utils.scm $site_dir/rx/source/irregex-utils.scm
    guild compile --r7rs $site_dir/rx/irregex.scm -o $lib_dir/rx/irregex.go
    guild compile --r7rs $site_dir/rx/source/irregex.scm -o $lib_dir/rx/source/irregex.go
    echo "==================="

    echo "install srfi-180"
    # guild compile will use relative path
    cd ${srfi}
    mkdir -p $lib_dir/srfi
    cp ${srfi}/srfi/srfi-180.scm $site_dir/srfi
    cp -R ${srfi}/srfi/srfi-180/ $site_dir/srfi
    cp -R ${srfi}/srfi/180/ $site_dir/srfi
    guild compile -x "sld" --r7rs $site_dir/srfi/srfi-180/helpers.sld -o $lib_dir/srfi/srfi-180/helpers.go
    guild compile --r7rs $site_dir/srfi/srfi-180.scm -o $lib_dir/srfi/srfi-180.go
    cd -
    echo "==================="

    echo "install json-rpc"
    mkdir -p $XDG_CACHE_HOME/json-rpc
    cp -r ${json-rpc}/* $XDG_CACHE_HOME/json-rpc
    cd $XDG_CACHE_HOME/json-rpc/guile
    echo $GUILE_LOAD_PATH
    echo $GUILE_LOAD_COMPILED_PATH
    echo `pwd`
    # configure will create file
    chmod -R +w $XDG_CACHE_HOME/json-rpc/guile
    ./configure --prefix=$build_dir
    make
    make install
    cd $build_dir
    mkdir -p $out/lib
    cp -r $build_dir/share $out
    cp -r $build_dir/lib $out
    echo "==================="
  '';

  configurePhase = ''
    mkdir -p ./temp
    cp -r ${src} ./temp/src
    chmod -R +w ./temp/src/guile
    # chmod -R +w ${src}/guile
    cd ./temp/src/guile
    # mkdir -p $out/bin
    # libdir is lsp-server.go output dir
    ./configure --prefix=$out --libdir=$out/lib
    cd -
  '';
  buildPhase = ''
    cd ./temp/src/guile
    autoreconf -i   # This will run automake and other needed autotools
    make
    cd -
  '';
  installPhase = ''
    runHook preInstall

    cd ./temp/src/guile
    make install
    cd -

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/guile-lsp-server \
      --set GUILE_LOAD_PATH "$out/share/guile/site/3.0" \
      --set GUILE_LOAD_COMPILED_PATH "$out/lib/guile/3.0/site-ccache" \
      --prefix PATH : ${lib.makeBinPath [ guile ]}
  '';

  meta = with lib; {
    description = "An LSP server for Scheme.";
    homepage = "https://codeberg.org/rgherdt/scheme-lsp-server";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
