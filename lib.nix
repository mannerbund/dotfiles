{
  hasImpermanence =
    config: builtins.hasAttr "environment" config && builtins.hasAttr "persistence" config.environment;

}
