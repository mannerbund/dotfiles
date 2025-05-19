{
  programs.texlive = {
    enable = true;
    extraPackages = texlive: {
      inherit
        (texlive)
        scheme-basic
        standalone
        dvisvgm
        wrapfig
        amsmath
        amsfonts
        ulem
        hyperref
        capt-of
        minted
        upquote
        polynom
        pgf
        collection-fontsrecommended
        ;
    };
  };
}
