{ lib
, stdenv
, fetchurl
, gettext
, gnome
, libgtop
, gtk3
, libhandy
, pcre2
, vte
, appstream-glib
, desktop-file-utils
, git
, meson
, ninja
, pkg-config
, python3
, sassc
, wrapGAppsHook
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "gnome-console";
  version = "43.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-console/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "t4TcSBVe86AkzYij9/650JO9mcZfKpcVo3+fu7Wq8VY=";
  };

  buildInputs = [
    gettext
    libgtop
    gtk3
    libhandy
    pcre2
    vte
  ] ++ lib.optionals stdenv.isLinux [
    gnome.nautilus
  ];

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    git
    meson
    ninja
    pkg-config
    python3
    sassc
    wrapGAppsHook
  ];

  mesonFlags = lib.optionals (!stdenv.isLinux) [
    "-Dnautilus=disabled"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  passthru.tests.test = nixosTests.terminal-emulators.kgx;

  meta = with lib; {
    description = "Simple user-friendly terminal emulator for the GNOME desktop";
    homepage = "https://gitlab.gnome.org/GNOME/console";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ zhaofengli ]);
    platforms = platforms.unix;
  };
}
