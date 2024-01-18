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
  count = local.number_of_domains * 2 # 2 For each domain, if it increases multiple the value and change the 2s below

  domain_id = element(local.domain_ids, floor(count.index / 2))

  record_type = "MX"
  target      = "in${count.index % 2 + 1}-smtp.messagingengine.com"
  priority    = (count.index % 2 + 1) * 10
  ttl_sec     = 0
  weight      = 0
}

resource "linode_domain_record" "dkim" {
  count = local.number_of_domains * 3 # 3 For each domain, if it increases multiple the value and change the 2s below

  domain_id = element(local.domain_ids, floor(count.index / 3))

  record_type = "CNAME"
  name        = "fm${count.index % 3 + 1}._domainkey"
  target      = "fm${count.index % 3 + 1}.${element(local.domain_names, floor(count.index / 3))}.dkim.fmhosted.com"
  priority    = 0
  ttl_sec     = 0
  weight      = 0
}

// FIXME: This might no longer be needed
resource "linode_domain_record" "legacy_dkim" {
  count = local.number_of_domains

  domain_id = element(local.domain_ids, count.index)

  record_type = "TXT"
  name        = "mesmtp._domainkey"
  target      = "mesmtp.${element(local.domain_names, floor(count.index / 3))}.dkim.fmhosted.com"
  priority    = 0
  ttl_sec     = 0
  weight      = 0
}

resource "linode_domain_record" "dmarc" {
  count = local.number_of_domains

  domain_id = element(local.domain_ids, count.index)

  record_type = "TXT"
  name        = "_dmarc"
  target      = "v=DMARC1; p=none;"
  priority    = 0
  ttl_sec     = 0
  weight      = 0
}

resource "linode_domain_record" "spf" {
  count = local.number_of_domains

  domain_id = element(local.domain_ids, count.index)

  record_type = "TXT"
  target      = "v=spf1 include:spf.messagingengine.com ?all"
  priority    = 0
  ttl_sec     = 0
  weight      = 0
}

resource "linode_domain_record" "autodiscovery" {
  for_each = {
    "submission" = {
      "weight" = 1
      "port"   = 587
      "target" = "smtp.fastmail.com"
    },
    "imaps" = {
      "weight" = 1
      "port"   = 993
      "target" = "imap.fastmail.com"
    },
    "pop3s" = {
      "weight"   = 1
      "port"     = 995
      "target"   = "pop.fastmail.com"
      "priority" = 10
    },
    "carddavs" = {
      "weight" = 1
      "port"   = 443
      "target" = "carddav.fastmail.com"
    },
    "caldavs" = {
      "weight" = 1
      "port"   = 443
      "target" = "caldav.fastmail.com"
    },
    "jmap" = {
      "port"   = 443
      "target" = "api.fastmail.com"
    },
    "autodiscovery" = {
      "port"   = 443
      "target" = "autodiscover.fastmail.com"
    },
    "imap"    = {},
    "pop3"    = {},
    "carddav" = {},
    "caldav"  = {},
  }

  domain_id = var.root_domain_id

  record_type = "SRV"
  protocol    = "tcp"
  service     = each.key
  target      = try(each.value.target, ".")
  port        = try(each.value.port, 0)
  priority    = try(each.value.priority, 0)
  weight      = try(each.value.weight, 0)
  ttl_sec     = 0
}

resource "linode_domain_record" "webmail" {
  domain_id   = var.root_domain_id
  name        = "mail"
  record_type = "CNAME"
  target      = "mail.fastmail.com"
  priority    = 0
  ttl_sec     = 0
  weight      = 0
}
