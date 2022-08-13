{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, gnome
, glib
, gtk4
, wrapGAppsHook4
, gettext
, itstool
, libadwaita
, libxml2
, libxslt
, docbook-xsl-nons
, docbook_xml_dtd_43
, systemd
, python3
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-logs";
  version = "43.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-logs/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "naBuiFhl7dG/vPILLU6HwVAGUXKdZW//E77pNlCTldQ=";
  };

  nativeBuildInputs = [
    python3
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gettext
    itstool
    libxml2
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_43
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    systemd
    gsettings-desktop-schemas
  ];

  mesonFlags = [
    "-Dman=true"
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-logs";
      attrPath = "gnome.gnome-logs";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Logs";
    description = "A log viewer for the systemd journal";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
