resource "linode_domain" "this" {
  type        = "master"
  domain      = "stephen.rebelinblue.com"
  soa_email   = var.soa_email
  refresh_sec = 0
  retry_sec   = 0
  ttl_sec     = 0
  tags        = ["managed_by:terraform"]
}

resource "linode_domain_record" "mx" {
  count = 2

  domain_id   = linode_domain.this.id
  record_type = "MX"
  target      = "in${count.index + 1}-smtp.messagingengine.com"
  priority    = (count.index + 1) * 10
  ttl_sec     = 0
  weight      = 0
}

resource "linode_domain_record" "domainkey" {
  count = 3

  domain_id   = linode_domain.this.id
  record_type = "CNAME"
  name        = "fm${count.index + 1}._domainkey"
  target      = "fm${count.index + 1}.${linode_domain.this.domain}.dkim.fmhosted.com"
  priority    = 0
  ttl_sec     = 0
  weight      = 0
}

resource "linode_domain_record" "dmarc" {
  domain_id   = linode_domain.this.id
  record_type = "TXT"
  name        = "_dmarc.stephen.rebelinblue.com"
  target      = "v=DMARC1; p=none;"
  priority    = 0
  ttl_sec     = 0
  weight      = 0
}


resource "linode_domain_record" "root_dmarc" {
  domain_id   = var.root_domain_id
  record_type = "TXT"
  name        = "_dmarc.rebelinblue.com"
  target      = "v=DMARC1; p=none;"
  priority    = 0
  ttl_sec     = 0
  weight      = 0
}

resource "linode_domain_record" "spf" {
  domain_id   = linode_domain.this.id
  record_type = "TXT"
  target      = "v=spf1 include:spf.messagingengine.com ?all"
  priority    = 0
  ttl_sec     = 0
  weight      = 0
}

resource "linode_domain_record" "root_mx" {
  count = 2

  domain_id   = var.root_domain_id
  record_type = "MX"
  target      = "in${count.index + 1}-smtp.messagingengine.com"
  priority    = (count.index + 1) * 10
  ttl_sec     = 0
  weight      = 0
}

resource "linode_domain_record" "root_sub_mx" {
  count = 2

  domain_id   = var.root_domain_id
  record_type = "MX"
  name        = "stephen"
  target      = "in${count.index + 1}-smtp.messagingengine.com"
  priority    = (count.index + 1) * 10
  ttl_sec     = 0
  weight      = 0
}

resource "linode_domain_record" "root_domainkey" {
  count = 3

  domain_id   = var.root_domain_id
  record_type = "CNAME"
  name        = "fm${count.index + 1}._domainkey"
  target      = "fm${count.index + 1}.rebelinblue.com.dkim.fmhosted.com"
  priority    = 0
  ttl_sec     = 0
  weight      = 0
}

resource "linode_domain_record" "root_spf" {
  domain_id   = var.root_domain_id
  record_type = "TXT"
  target      = "v=spf1 include:spf.messagingengine.com ?all"
  priority    = 0
  ttl_sec     = 0
  weight      = 0
}

// FIXME: These might no longer be needed
resource "linode_domain_record" "root_legacy_domainkey" {
  domain_id   = var.root_domain_id
  record_type = "TXT"
  name        = "mesmtp._domainkey"
  target      = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCkRePAzQ+NXqMBX/7ZVDmei5+NUum/9yhUcTC7eGBQygnvowJolc1CqcHGCcCiZWhjtX372uZj8oyaFtgfdZtokgop1B60ZiBimTPoXvbdd7iX7zyDXYBa1HubqCh2es4Gex+lF8uaqS7lnltDTyjUV1kN3DlkCJjXufvBwEXTOwIDAQAB"
  port        = 80
  priority    = 10
  ttl_sec     = 0
  weight      = 5
}

resource "linode_domain_record" "legacy_domainkey" {
  domain_id   = var.root_domain_id
  record_type = "TXT"
  name        = "mesmtp._domainkey.stephen"
  target      = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDMfgWVBMV4wfkdrHa5TGTpQwzVGguEx6Eloni4mtfdcmaZ/zFf0cYfxJ+1D5h313+IPfk7YW7mV9QrEx3G0rnfMMNeIlqHP6FkDd6IBchVl9UeRDItRGW9Cy/g+7SxibmiELPEGI9kw1A25IoDQEFws/3hMQLhqXRbsWdQIxWnowIDAQAB"
  port        = 80
  priority    = 10
  ttl_sec     = 0
  weight      = 5
}

// TODO: Add DMARC and auto discovery https://www.fastmail.help/hc/en-us/articles/360060591153-Manual-DNS-configuration
