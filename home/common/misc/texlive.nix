{
  programs.texlive = {
    enable = true;
    extraPackages = texlive: {
      inherit
        (texlive)
        scheme-basic
        collection-fontsrecommended
        geometry
        standalone
        dvisvgm
        wrapfig
        mathtools
        amsmath
        amsfonts
        ulem
        hyperref
        capt-of
        minted
        upquote
        polynom
        longdivision
        pgf
        ;
    };
  };
}
