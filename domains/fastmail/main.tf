resource "linode_domain" "this" {
  type = "master"

  domain      = "stephen.${var.domain_apex}"
  soa_email   = var.soa_email
  refresh_sec = 0
  retry_sec   = 0
  ttl_sec     = 0

  tags = ["managed_by:terraform"]
}

resource "linode_domain_record" "mx" {
  count = length(local.domains) * 2 # 2 For each domain, if it increases multiple the value and change the 2s below

  domain_id = element(values(local.domains), floor(count.index / 2))

  record_type = "MX"
  target      = "in${count.index % 2 + 1}-smtp.messagingengine.com"
  priority    = (count.index % 2 + 1) * 10
  ttl_sec     = 0
  weight      = 0
}

resource "linode_domain_record" "domainkey" {
  count = length(local.domains) * 3 # 3 For each domain, if it increases multiple the value and change the 2s below

  domain_id = element(values(local.domains), floor(count.index / 3))

  record_type = "CNAME"
  name        = "fm${count.index % 3 + 1}._domainkey"
  target      = "fm${count.index % 3 + 1}.${element(keys(local.domains), floor(count.index / 3))}.dkim.fmhosted.com"
  priority    = 0
  ttl_sec     = 0
  weight      = 0
}

resource "linode_domain_record" "dmarc" {
  count = length(local.domains)

  domain_id = element(values(local.domains), count.index)

  record_type = "TXT"
  name        = "_dmarc"
  target      = "v=DMARC1; p=none;"
  priority    = 0
  ttl_sec     = 0
  weight      = 0
}

resource "linode_domain_record" "spf" {
  count = length(local.domains)

  domain_id = element(values(local.domains), count.index)

  record_type = "TXT"
  target      = "v=spf1 include:spf.messagingengine.com ?all"
  priority    = 0
  ttl_sec     = 0
  weight      = 0
}

// FIXME: This might no longer be needed
resource "linode_domain_record" "legacy_domainkey" {
  count = length(local.domains)

  domain_id = element(values(local.domains), count.index)

  record_type = "TXT"
  name        = "mesmtp._domainkey"
  target      = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDMfgWVBMV4wfkdrHa5TGTpQwzVGguEx6Eloni4mtfdcmaZ/zFf0cYfxJ+1D5h313+IPfk7YW7mV9QrEx3G0rnfMMNeIlqHP6FkDd6IBchVl9UeRDItRGW9Cy/g+7SxibmiELPEGI9kw1A25IoDQEFws/3hMQLhqXRbsWdQIxWnowIDAQAB"
  port        = 80
  priority    = 10
  ttl_sec     = 0
  weight      = 5
}

# resource "linode"

// TODO: Add auto discovery https://www.fastmail.help/hc/en-us/articles/360060591153-Manual-DNS-configuration
