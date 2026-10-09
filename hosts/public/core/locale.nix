{ lib, ... }:
{
  i18n.defaultLocale = lib.mkDefault "C.UTF-8";
  time.timeZone = lib.mkDefault "Europe/Moscow";
}
