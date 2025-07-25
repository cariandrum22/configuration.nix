{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.security.certificates;
in
{
  options.modules.security.certificates = {
    enableInternalCAs = mkOption {
      type = types.bool;
      default = false;
      description = "Enable internal Certificate Authorities";
    };
  };

  config = mkIf cfg.enableInternalCAs {
    security.pki.certificates = [
      ''
        codeTakt Certificate Authority
              -----BEGIN CERTIFICATE-----
              MIIDjjCCAnagAwIBAgIBATANBgkqhkiG9w0BAQsFADA3MRUwEwYDVQQKDAxDT0RF
              VEFLVC5ORVQxHjAcBgNVBAMMFUNlcnRpZmljYXRlIEF1dGhvcml0eTAeFw0xOTEx
              MjIwNjAyNTNaFw0zOTExMjIwNjAyNTNaMDcxFTATBgNVBAoMDENPREVUQUtULk5F
              VDEeMBwGA1UEAwwVQ2VydGlmaWNhdGUgQXV0aG9yaXR5MIIBIjANBgkqhkiG9w0B
              AQEFAAOCAQ8AMIIBCgKCAQEAwngLoXGv7XrJOlZWjEkjw15QfwA3Ua1yf8643gWc
              kRwa8LTgzM9lcXksrUbEctWf2rexsCAEmmWfve5kpMlMN6YC01DX7SIO+vHgOGyy
              bOiz5vNCIiK+0UWOkhFfsoUU+GcxKDTZREuKh3mqv2rEqWBuI7PuoqeSJlU+apQq
              sZEBJGvgzIDm+C7WLxwt7MToebmZh92GIOjDmDRxA0XlD76PVscho4908iiEyCvG
              5Q456n3rkU/zV1ZTnaH9oZmqc3QvqYDe1s8a5vEM5qdh3eV+tsd+g4y9AM9Eau63
              iLugLWitVYEDL48rmN19r/58sqWVsMpjT2EnD0nz+xhGPQIDAQABo4GkMIGhMB8G
              A1UdIwQYMBaAFPnuPun1/b+wl30K9y4nAoVeI4RvMA8GA1UdEwEB/wQFMAMBAf8w
              DgYDVR0PAQH/BAQDAgHGMB0GA1UdDgQWBBT57j7p9f2/sJd9CvcuJwKFXiOEbzA+
              BggrBgEFBQcBAQQyMDAwLgYIKwYBBQUHMAGGImh0dHA6Ly9pcGEtY2EuY29kZXRh
              a3QubmV0L2NhL29jc3AwDQYJKoZIhvcNAQELBQADggEBAJFpP/9IjD/z42Kj5abk
              t2NGooqesRhE82CwipVO13+v+KXo3bOsjlfEjXzFEH5okAmnfR0O2OWqw0Shf8km
              76YWg5WA0MnRNipF3S7+ylS0Ph3UNhE/L4ZGP0EzCOpq6isWtJ5OCsGsornltaIT
              /fMqhXvkP43UryvaYEhZcOWTRiafX7i9li/bCllNjHmVC9j4e4OIcCcIeSkqhiwo
              NVq+A1FO+T8k7psxkQVCFLacQjndrZb8huz3a0vjwYB8EsMwiYKVtlBZ/bX/3WSJ
              YEv84dUJXiUJyTo+WzWIUC9kfMEdHhqUHE2FUY4nVl7Q/h/cBcQ7Swz3Y/v4W0Jt
              Ct0=
              -----END CERTIFICATE-----
      ''
      ''
        codeTakt Private CA
              -----BEGIN CERTIFICATE-----
              MIICejCCAgCgAwIBAgIRANdw07aDMe5KhgbodrLFiFEwCgYIKoZIzj0EAwQwfjEL
              MAkGA1UEBhMCSlAxFjAUBgNVBAoMDWNvZGVUYWt0IEluYy4xFDASBgNVBAsMC0Rl
              dmVsb3BtZW50MQ4wDAYDVQQIDAVUb2t5bzEcMBoGA1UEAwwTY29kZVRha3QgUHJp
              dmF0ZSBDQTETMBEGA1UEBwwKU2hpYnV5YS1rdTAeFw0xOTExMjYwNTI1MjJaFw0y
              OTExMjYwNjI1MjJaMH4xCzAJBgNVBAYTAkpQMRYwFAYDVQQKDA1jb2RlVGFrdCBJ
              bmMuMRQwEgYDVQQLDAtEZXZlbG9wbWVudDEOMAwGA1UECAwFVG9reW8xHDAaBgNV
              BAMME2NvZGVUYWt0IFByaXZhdGUgQ0ExEzARBgNVBAcMClNoaWJ1eWEta3UwdjAQ
              BgcqhkjOPQIBBgUrgQQAIgNiAATypj4PfjyJ00Oqnn8p4oe52KiI4VY8yVMzAXJZ
              8UhKM/m8g5RoikybfWNKIZCWRlohRE4TTOlpO0l3vM127gHO8K6kDCb9uVknATlT
              nj2fjfqqXNFy14LsF7QajROAh4+jQjBAMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0O
              BBYEFK1XXr6REF11KaQ+hJDQj6c7Dh4XMA4GA1UdDwEB/wQEAwIBhjAKBggqhkjO
              PQQDBANoADBlAjEA4ednIirq9s0jshdZrKh0EPf9hrjeqi3jY0GhyiblMrXI2Evh
              uVEFN1QSIN6SrQQCAjAaDkMlWHFtTSlxFe8RZ89kH1HLhW/rWU5EK9g0vnTPJWin
              aEPo+6fY6HPnBEZ8WoE=
              -----END CERTIFICATE-----
      ''
    ];
  };
}
